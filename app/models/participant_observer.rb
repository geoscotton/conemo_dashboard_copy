# frozen_string_literal: true
# Hook into Participant lifecycle events.
class ParticipantObserver < ActiveRecord::Observer
  attr_reader :participant

  PUSHABLE_RESOURCES = %w(
    Device
    ExceptionReport
    HelpMessage
    Login
    SessionEvent
    PlannedActivity
  ).freeze
  SYNCABLE_RESOURCES = %w(
    ContentAccessEvent
    ParticipantStartDate
  ).freeze

  def after_save(participant)
    @participant = participant
    create_pushable_resources
    create_syncable_resources

    return unless participant.nurse

    create_tasks
  end

  def after_create(participant)
    @participant = participant
    create_configuration_token
  end

  private

  def create_tasks
    Tasks::ConfirmationCall.create(participant: participant)
  end

  def create_pushable_resources
    PUSHABLE_RESOURCES.each do |resource_name|
      next if TokenAuth::SynchronizableResource.exists?(
        entity_id: participant.id,
        class_name: resource_name
      )

      TokenAuth::SynchronizableResource.create!(
        entity_id: participant.id,
        entity_id_attribute_name: "participant_id",
        name: resource_name.underscore.pluralize,
        class_name: resource_name,
        is_pullable: false,
        is_pushable: true
      )
    end
  end

  def create_syncable_resources
    SYNCABLE_RESOURCES.each do |resource_name|
      next if TokenAuth::SynchronizableResource.exists?(
        entity_id: participant.id,
        class_name: resource_name
      )

      TokenAuth::SynchronizableResource.create!(
        entity_id: participant.id,
        entity_id_attribute_name: "participant_id",
        name: resource_name.underscore.pluralize,
        class_name: resource_name,
        is_pullable: true,
        is_pushable: true
      )
    end
  end

  def create_configuration_token
    TokenAuth::ConfigurationToken.create entity_id: participant.id
  end
end
