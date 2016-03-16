# frozen_string_literal: true
# Presentation and ordering logic for the contact points/call notes.
class ParticipantContactPresenter
  attr_reader :participant, :contact

  delegate :id, to: :contact

  # includes Notes (PatientContacts)
  def self.scheduled_contacts_for(participant)
    contacts = [
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

  # excludes Notes (PatientContacts)
  def self.all_contacts_for(participant, reverse=true)
    contacts = [
      AdditionalContact,
      CallToScheduleFinalAppointment,
      FinalAppointment,
      FirstAppointment,
      FirstContact,
      HelpRequestCall,
      LackOfConnectivityCall,
      NonAdherenceCall,
      SecondContact,
      ThirdContact
    ].map do |contact_class|
      contact_class.where(participant: participant).to_a
    end.flatten

    contacts
      .map { |c| new(c) }
      .sort do |a, b|
        reverse ? b.timestamp <=> a.timestamp : a.timestamp <=> b.timestamp
      end
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
    contact.try(:note) || contact.try(:notes)
  end

  def timestamp
    contact.try(:contact_at) || contact.try(:scheduled_at) ||
      contact.try(:appointment_at)
  end
end
