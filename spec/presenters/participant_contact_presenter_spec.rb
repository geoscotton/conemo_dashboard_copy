# frozen_string_literal: true
require "rails_helper"

RSpec.describe ParticipantContactPresenter do
  let(:now) { Time.zone.now }
  let(:participant) { Participant.new }
  let(:contacts) do
    [
      FinalAppointment.new(appointment_at: now, participant: participant,
                           notes: "x"),
      FirstAppointment.new(appointment_at: now, participant: participant,
                           notes: "x"),
      PatientContact.new(contact_at: now, participant: participant, note: "x"),
      SecondContact.new(contact_at: now, participant: participant, notes: "x"),
      ThirdContact.new(contact_at: now, participant: participant, notes: "x")
    ]
  end

  describe "#note" do
    it "returns a description of each contact" do
      contacts.each do |contact|
        expect(ParticipantContactPresenter.new(contact).note).to be_a String
      end
    end
  end

  describe "#timestamp" do
    it "returns a time for each type of contact" do
      contacts.each do |contact|
        expect(ParticipantContactPresenter.new(contact).timestamp).to be_a Time
      end
    end
  end
end
