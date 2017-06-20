# frozen_string_literal: true
# Virtual model (not DB-backed) for reporting exceptions to Sentry.
class ExceptionReport
  include ActiveModel::Model
  include ActiveModel::Serialization

  attr_accessor :id, :uuid, :url, :app_version, :cause, :stack_trace,
                :occurred_at

  def self.find_or_initialize_by(attributes)
    new uuid: attributes[:uuid]
  end

  def update(attributes)
    self.id = uuid

    if defined? Raven
      Raven.user_context id: attributes["participant_id"]
      Raven.capture_message(
        "JavaScript exception: #{attributes['cause']}",
        level: "error",
        extra: {
          attributes: attributes,
          release: "app v#{attributes['app_version']}"
        }
      )
    end

    true
  end
end
