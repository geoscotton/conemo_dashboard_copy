# frozen_string_literal: true

require "rails_helper"

RSpec.describe "tasks/index", type: :view do
  let(:template) { "tasks/index" }
  let(:tasks) do
    instance_double(ParticipantSummaryPresenter,
                    id: rand,
                    study_identifier: "1234",
                    tasks: [],
                    active_tasks: [],
                    overdue_tasks: [],
                    scheduled_tasks: [],
                    latest_notification_at: nil)
  end

  it "renders a progress bar with all tasks" do
    assign(:tasks, tasks)
    completed_task = instance_double(NurseTask,
                                     to_s: "completed task 1",
                                     active?: false)
    allow(tasks).to receive(:scheduled_tasks) { [completed_task] }

    render template: template

    expect(rendered).to include "completed task 1"
  end

  it "renders the participant study id" do
    assign(:tasks, tasks)

    render template: template

    expect(rendered).to include "Patient 1234"
  end

  it "renders the assigned active task count" do
    assign(:tasks, tasks)
    allow(tasks).to receive(:active_tasks) { %w( 1 2 3 4 5 ) }

    render template: template

    expect(rendered).to include "5 tasks"
  end

  it "renders the overdue task count" do
    assign(:tasks, tasks)
    allow(tasks).to receive(:overdue_tasks) { ["task 1", "task 2"] }

    render template: template

    expect(rendered).to include "2 overdue"
  end

  it "renders the time before/until each task" do
    I18n.locale = "en"
    task = instance_double(NurseTask,
                           to_s: "Do fu",
                           scheduled_at: 1.minute.ago,
                           active?: true).as_null_object
    task2 = instance_double(NurseTask,
                            to_s: "Do ba",
                            scheduled_at: 2.hours.from_now,
                            active?: true).as_null_object
    assign(:tasks, tasks)
    allow(tasks).to receive(:tasks) { [task, task2] }

    render template: template

    expect(rendered).to match(/Do fu .*1 minute ago/)
    expect(rendered).to match(/Do ba .*in about 2 hours/)
  end

  context "for alert tasks" do
    def stub_alert_tasks
      task = instance_double(NurseTask,
                             active?: true,
                             scheduled_at: Time.zone.now,
                             alert?: true).as_null_object
      assign(:tasks, tasks)
      allow(tasks).to receive(:tasks) { [task] }
    end

    it "renders a 'Mark as resolved' button" do
      stub_alert_tasks

      render template: template

      expect(rendered).to include "Mark as resolved"
    end

    it "renders a 'Contact Supervisor' button" do
      stub_alert_tasks

      render template: template

      expect(rendered).to include "Contact Supervisor"
    end

    it "renders the timestamp of the last supervisor notification" do
      stub_alert_tasks
      allow(tasks).to receive(:latest_notification_at) { Time.zone.now }

      render template: template

      expect(rendered).to include "last supervisor contact sent "
    end
  end

  context "for scheduled tasks" do
    def stub_scheduled_tasks
      task = instance_double(NurseTask,
                             active?: true,
                             scheduled_at: Time.zone.now,
                             target: :first_contact,
                             alert?: false).as_null_object
      assign(:tasks, tasks)
      allow(tasks).to receive(:tasks) { [task] }
    end

    it "renders a 'Confirm' link" do
      stub_scheduled_tasks

      render template: template

      expect(rendered).to include "Confirm"
    end

    it "renders a 'Cancel' link" do
      stub_scheduled_tasks

      render template: template

      expect(rendered).to include "Cancel"
    end
  end
end
