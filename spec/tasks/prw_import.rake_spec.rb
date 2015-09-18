require "spec_helper"
require "rake"

describe "prw_import:sync" do
  fixtures :all

  let(:task_path) { "lib/tasks/prw_import" }

  subject { Rake::Task["prw_import:sync"] }

  def loaded_files_excluding_current_rake_file
    $LOADED_FEATURES.reject do |file|
      file == Rails.root.join("#{task_path}.rake").to_s
    end
  end

  def prepare_task
    Rake.application.rake_require(task_path,
                                  [Rails.root.to_s],
                                  loaded_files_excluding_current_rake_file)
    Rake::Task.define_task(:environment)
    allow($stdout).to receive(:write) # Hiding puts output
  end

  def arrange_stubs
    allow(StartDate).to receive(:all) { [] }
    allow(AppLogin).to receive(:all) { [] }
    allow(LessonDatum).to receive(:all) { [] }
    allow(DialogueDatum).to receive(:all) { [] }
    allow(StaffMessage).to receive(:all) { [] }
  end

  describe "SessionEvent imports" do
    let(:participant) { Participant.first }
    let(:lesson) { Lesson.first }

    context "when no access events for a session have been imported" do
      it "imports a new one" do
        prepare_task
        access_event =
          instance_double(ClientSessionEvent,
                          event_type: ClientSessionEvent::TYPES.access,
                          participant_identifier: participant.study_identifier,
                          lesson_guid: lesson.guid,
                          occurred_at: Time.zone.now)
        allow(ClientSessionEvent).to receive(:access_events) { [access_event] }

        subject.reenable

        expect { subject.invoke }.to change { SessionEvent.count }.by(1)
      end
    end

    context "when the participant does not exist" do
      it "does not import a new one" do
        prepare_task
        access_event =
          instance_double(ClientSessionEvent,
                          event_type: ClientSessionEvent::TYPES.access,
                          participant_identifier: "baz",
                          lesson_guid: lesson.guid,
                          occurred_at: Time.zone.now)
        allow(ClientSessionEvent).to receive(:access_events) { [access_event] }

        subject.reenable

        expect { subject.invoke }.not_to change { SessionEvent.count }
      end
    end

    context "when the lesson does not exist" do
      it "does not import a new one" do
        prepare_task
        access_event =
          instance_double(ClientSessionEvent,
                          event_type: ClientSessionEvent::TYPES.access,
                          participant_identifier: participant.study_identifier,
                          lesson_guid: "baz",
                          occurred_at: Time.zone.now)
        allow(ClientSessionEvent).to receive(:access_events) { [access_event] }

        subject.reenable

        expect { subject.invoke }.not_to change { SessionEvent.count }
      end
    end

    context "when the access event for a session has been imported" do
      it "does not import it again" do
        prepare_task
        now = Time.zone.now
        access_event =
          instance_double(ClientSessionEvent,
                          event_type: ClientSessionEvent::TYPES.access,
                          participant_identifier: participant.study_identifier,
                          lesson_guid: lesson.guid,
                          occurred_at: now)
        allow(ClientSessionEvent).to receive(:access_events) { [access_event] }
        SessionEvent.create!(
          participant: participant,
          lesson: lesson,
          event_type: ClientSessionEvent::TYPES.access,
          occurred_at: now
        )

        subject.reenable

        expect { subject.invoke }.not_to change { SessionEvent.count }
      end
    end

    context "when another access event for a session has been imported" do
      it "imports a new one for the session" do
        prepare_task
        now = Time.zone.now
        access_event =
          instance_double(ClientSessionEvent,
                          event_type: ClientSessionEvent::TYPES.access,
                          participant_identifier: participant.study_identifier,
                          lesson_guid: lesson.guid,
                          occurred_at: now)
        allow(ClientSessionEvent).to receive(:access_events) { [access_event] }
        SessionEvent.create!(
          participant: participant,
          lesson: lesson,
          event_type: ClientSessionEvent::TYPES.access,
          occurred_at: now + 1.second
        )

        subject.reenable

        expect { subject.invoke }.to change { SessionEvent.count }.by(1)
      end
    end
  end
end
