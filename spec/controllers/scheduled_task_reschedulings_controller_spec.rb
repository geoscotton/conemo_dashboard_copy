# frozen_string_literal: true
require "rails_helper"

RSpec.describe ScheduledTaskReschedulingsController, type: :controller do
  fixtures :all

  let(:locale) { LOCALES.values.sample }
  let(:participant) do
    Participant.active.where.not(nurse: nil).find_by(locale: locale)
  end
  let(:nurse) { participant.nurse }
  let(:task) do
    NurseTask.destroy_all
    Tasks::ConfirmationCall.create!(participant: participant).tap do |t|
      allow(t).to receive(:update)
    end
  end
  let(:tasks) { double("NurseTasks").as_null_object }
  let(:valid_params) do
    {
      explanation: "asdf",
      scheduled_at: Time.zone.now,
      old_scheduled_at: Time.zone.now
    }
  end

  shared_examples "a bad request" do
    it do
      expect(response).to redirect_to nurse_dashboard_url(nurse)
    end
  end

  def authorize_nurse
    allow(controller).to receive(:authorize!)
    sign_in_user nurse
  end

  def stub_tasks
    allow(NurseTask).to receive(:for_participant)
      .with(participant)
      .and_return(tasks)
  end

  describe "POST create" do
    context "for an unauthenticated request" do
      before do
        post :create, participant_id: participant.id, locale: locale,
                      task_id: rand, scheduled_task_rescheduling: valid_params
      end

      it_behaves_like "a rejected user action"
    end

    context "for an authenticated nurse" do
      def stub_task
        stub_tasks
        allow(tasks).to receive(:find) { task }
      end

      context "when the Participant isn't found" do
        before do
          sign_in_user nurse

          post :create, participant_id: -1, locale: locale, task_id: rand,
                        scheduled_task_rescheduling: valid_params
        end

        it_behaves_like "a bad request"
      end

      context "when the Task isn't found" do
        before do
          sign_in_user nurse

          post :create, participant_id: participant.id, locale: locale,
                        task_id: -1, scheduled_task_rescheduling: valid_params
        end

        it_behaves_like "a bad request"
      end

      it "updates the task's status" do
        authorize_nurse
        stub_task

        post :create, participant_id: participant.id, locale: locale,
                      task_id: rand, scheduled_task_rescheduling: valid_params

        expect(task).to have_received(:update)
      end

      context "when successful" do
        it "sets the flash notice" do
          authorize_nurse
          stub_task
          allow(task).to receive(:update) { true }

          post :create, participant_id: participant.id, locale: locale,
                        task_id: rand, scheduled_task_rescheduling: valid_params

          expect(flash[:notice]).not_to be_blank
        end
      end

      context "when unsuccessful" do
        it "sets the flash alert" do
          authorize_nurse
          stub_task
          allow(task).to receive(:update) { false }
          allow(task).to receive_message_chain("errors.full_messages") { [] }

          post :create, participant_id: participant.id, locale: locale,
                        task_id: rand, scheduled_task_rescheduling: valid_params

          expect(flash[:alert]).not_to be_blank
        end
      end

      it "redirects to the tasks page" do
        authorize_nurse
        stub_tasks
        allow(tasks).to receive(:find) { task }

        post :create, participant_id: participant.id, locale: locale,
                      task_id: rand, scheduled_task_rescheduling: valid_params

        expect(response).to redirect_to participant_tasks_url(participant)
      end
    end
  end
end
