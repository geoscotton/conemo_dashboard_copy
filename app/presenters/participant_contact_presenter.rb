# frozen_string_literal: true
# Presentation and ordering logic for the contact points/call notes.
class ParticipantContactPresenter
  attr_reader :participant, :contact

  delegate :id, to: :contact

  def self.for(participant)
    contacts = [
      AdditionalContact,
      CallToScheduleFinalAppointment,
      FinalAppointment,
      FirstAppointment,
      PatientContact,
      SecondContact,
      ThirdContact
    ].map do |contact_class|
      contact_class.where(participant: participant).to_a
    end.flatten

    contacts
      .map { |c| new(c) }
      .sort { |a, b| b.timestamp <=> a.timestamp }
  end

  def initialize(contact)
    @participant = contact.participant
    @contact = contact
  end

  def title
    contact.model_name.human
  end

  def deletable?
    contact.is_a? PatientContact
  end

  def note
    if contact.is_a? PatientContact
      contact.note
    else
      contact.try(:notes)
    end
  end

  def timestamp
    if appointment?
      contact.appointment_at
    else
      contact.contact_at
    end
  end

  def appointment?
    [FinalAppointment, FirstAppointment].any? { |klass| contact.is_a?(klass) }
  end
end
