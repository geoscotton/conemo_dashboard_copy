# frozen_string_literal: true
require "rails_helper"

module TokenAuth
  RSpec.describe AuthenticationTokenObserver do
    fixtures :all

    let(:observer) { AuthenticationTokenObserver.instance }
    let!(:device) do
      Device.create!(
        participant: Participant.first,
        uuid: SecureRandom.uuid,
        device_uuid: SecureRandom.uuid,
        manufacturer: "Samsung",
        model: "G123",
        platform: "Android",
        device_version: "5.1.1",
        inserted_at: Time.zone.now,
        last_seen_at: Time.zone.now
      )
    end
    let(:token) { double("token", entity_id: device.participant_id) }

    context "when an Authentication Token is destroyed" do
      it "creates a Past Device Assignment record for the Participant" do
        expect do
          observer.after_destroy(token)
        end.to change {
          PastDeviceAssignment.where(participant_id: token.entity_id).count
        }.by(1)
      end

      it "destroys the Participant's original Device record" do
        expect do
          observer.after_destroy(token)
        end.to change {
          Device.where(participant_id: token.entity_id).count
        }.by(-1)
      end
    end
  end
end
