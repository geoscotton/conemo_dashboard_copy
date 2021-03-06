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
  let(:smartphone) { instance_double(Smartphone).as_null_object }
  let(:now) { Time.zone.now }
  let(:participant) do
    instance_double(Participant,
                    id: rand,
                    date_of_birth: now,
                    smartphone: smartphone).as_null_object.tap do |p|
      allow(smartphone).to receive(:participant) { p }
    end
  end

  def stub_data
    assign(:tasks, tasks)
    assign(:participant, participant)
    allow(view).to receive(:can?)
  end

  before { I18n.locale = "en" }

  it "renders a progress bar with all tasks" do
    stub_data
    completed_task = instance_double(
      TaskPresenter,
      css_class: "foo",
      task: Tasks::FollowUpCallWeekOne.new,
      scheduled_at: Time.zone.parse("2014-03-04T12:00:00Z"),
      due?: true
    )
    allow(tasks).to receive(:scheduled_tasks) { [completed_task] }

    render template: template

    expect(rendered).to have_selector(".progress-bar-foo",
                                      text: "Follow up call week 1")
    expect(rendered).to have_selector(".progress-bar-foo",
                                      text: "March 04, 2014")
  end

  it "renders the assigned active task count" do
    stub_data
    allow(tasks)
      .to receive(:active_tasks)
      .and_return(
        [
          Tasks::ConfirmationCall.new(
            scheduled_at: now, overdue_at: now, id: rand
          ),
          Tasks::HelpRequest.new(
            scheduled_at: now, overdue_at: now, id: rand
          ),
          Tasks::NonAdherenceCall.new(
            scheduled_at: now, overdue_at: now, id: rand
          )
        ].map { |t| TaskPresenter.new(t) }
      )

    render template: template

    expect(rendered).to include "3 Tasks"
  end

  it "renders the overdue task count" do
    stub_data
    allow(tasks).to receive(:overdue_tasks) { ["task 1", "task 2"] }

    render template: template

    expect(rendered).to include "2 Overdue"
  end

  it "renders the time since each task was scheduled" do
    task = Tasks::FollowUpCallWeekOne.new(
      scheduled_at: 1.minute.ago, overdue_at: now, id: rand
    )
    stub_data
    allow(tasks).to receive(:active_tasks) { [TaskPresenter.new(task)] }

    render template: template

    expect(rendered).to match(/Follow up call week 1 .*1 minute ago/)
  end

  context "for alert tasks" do
    def stub_alert_tasks
      task = Tasks::LackOfConnectivityCall.new(scheduled_at: now,
                                               overdue_at: now,
                                               id: rand)
      stub_data
      allow(tasks).to receive(:active_tasks) { [TaskPresenter.new(task)] }
    end

    context "for a Nurse" do
      it "renders a 'Mark as resolved' button" do
        stub_alert_tasks
        allow(view).to receive(:can?) { true }

        render template: template

        expect(rendered).to include "Mark as resolved"
      end
    end

    context "for a Nurse" do
      it "renders a 'Contact supervisor' button" do
        stub_alert_tasks
        allow(view).to receive(:can?) { true }

        render template: template

        expect(rendered).to include "Contact supervisor"
      end
    end

    it "renders the timestamp of the last supervisor notification" do
      stub_alert_tasks
      notification = instance_double(SupervisorNotification,
                                     created_at: now)
      allow(tasks).to receive(:latest_notification) { notification }

      render template: template

      expect(rendered).to include "Last supervisor contact sent "
    end
  end

  context "for scheduled tasks" do
    def stub_scheduled_tasks
      task = instance_double(NurseTask,
                             scheduled_at: now,
                             target: :first_contact,
                             alert?: false).as_null_object
      stub_data
      allow(tasks).to receive(:active_tasks) { [TaskPresenter.new(task)] }
    end

    it "renders a 'Confirm' link" do
      stub_scheduled_tasks

      render template: template

      expect(rendered).to include "Confirm"
    end

    context "for a Nurse" do
      it "renders a 'Cancel' link" do
        stub_scheduled_tasks
        allow(view).to receive(:can?) { true }

        render template: template

        expect(rendered).to include "Cancel"
      end
    end
  end
end
