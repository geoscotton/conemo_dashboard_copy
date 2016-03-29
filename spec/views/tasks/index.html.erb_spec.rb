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
                    latest_notification: nil)
  end

  it "renders a progress bar with all tasks" do
    assign(:tasks, tasks)
    completed_task = instance_double(TaskPresenter,
                                     to_s: "completed task 1",
                                     css_class: "foo")
    allow(tasks).to receive(:scheduled_tasks) { [completed_task] }

    render template: template

    expect(rendered)
      .to have_selector(".progress-bar-foo", text: "completed task 1")
  end

  it "renders the assigned active task count" do
    I18n.locale = "en"
    assign(:tasks, tasks)
    allow(tasks)
      .to receive(:active_tasks)
      .and_return(
        [
          Tasks::ConfirmationCall.new(scheduled_at: Time.zone.now, id: rand),
          Tasks::HelpRequest.new(scheduled_at: Time.zone.now, id: rand),
          Tasks::NonAdherenceCall.new(scheduled_at: Time.zone.now, id: rand)
        ]
      )

    render template: template

    expect(rendered).to include "3 Tasks"
  end

  it "renders the overdue task count" do
    assign(:tasks, tasks)
    allow(tasks).to receive(:overdue_tasks) { ["task 1", "task 2"] }

    render template: template

    expect(rendered).to include "2 overdue"
  end

  it "renders the time since each task was scheduled" do
    I18n.locale = "en"
    task = Tasks::FollowUpCallWeekOne.new(scheduled_at: 1.minute.ago, id: rand)
    assign(:tasks, tasks)
    allow(tasks).to receive(:active_tasks) { [task] }

    render template: template

    expect(rendered).to match(/Follow up call week 1 .*1 minute ago/)
  end

  context "for alert tasks" do
    def stub_alert_tasks
      task = Tasks::LackOfConnectivityCall.new(scheduled_at: Time.zone.now,
                                               id: rand)
      assign(:tasks, tasks)
      allow(tasks).to receive(:active_tasks) { [task] }
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
      notification = instance_double(SupervisorNotification,
                                     created_at: Time.zone.now)
      allow(tasks).to receive(:latest_notification) { notification }

      render template: template

      expect(rendered).to include "last supervisor contact sent "
    end
  end

  context "for scheduled tasks" do
    def stub_scheduled_tasks
      task = instance_double(NurseTask,
                             scheduled_at: Time.zone.now,
                             target: :first_contact,
                             alert?: false).as_null_object
      assign(:tasks, tasks)
      allow(tasks).to receive(:active_tasks) { [task] }
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
