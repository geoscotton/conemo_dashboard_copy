# frozen_string_literal: true
require "rails_helper"

RSpec.describe ParticipantContactPresenter do
  let(:now) { Time.zone.now }
  let(:participant) { Participant.new }
  let(:notable_contacts) do
    [
      FinalAppointment.new(participant: participant, notes: "x"),
      FirstAppointment.new(participant: participant, notes: "x"),
      PatientContact.new(participant: participant, note: "x"),
      SecondContact.new(participant: participant, notes: "x"),
      ThirdContact.new(participant: participant, notes: "x")
    ]
  end
  let(:timestamped_contacts) do
    [
      AdditionalContact.new(scheduled_at: now, participant: participant),
      CallToScheduleFinalAppointment.new(contact_at: now,
                                         participant: participant),
      FinalAppointment.new(appointment_at: now, participant: participant),
      FirstAppointment.new(appointment_at: now, participant: participant),
      FirstContact.new(contact_at: now, participant: participant),
      HelpRequestCall.new(contact_at: now, participant: participant),
      LackOfConnectivityCall.new(contact_at: now, participant: participant),
      NonAdherenceCall.new(contact_at: now, participant: participant),
      PatientContact.new(contact_at: now, participant: participant),
      SecondContact.new(contact_at: now, participant: participant),
      ThirdContact.new(contact_at: now, participant: participant)
    ]
  end

  describe "#note" do
    it "returns a description of each contact" do
      notable_contacts.each do |contact|
        expect(ParticipantContactPresenter.new(contact).note).to be_a String
      end
    end
  end

  describe "#timestamp" do
    it "returns a time for each type of contact" do
      timestamped_contacts.each do |contact|
        expect(ParticipantContactPresenter.new(contact).timestamp).to be_a Time
      end
    end
  end
end
