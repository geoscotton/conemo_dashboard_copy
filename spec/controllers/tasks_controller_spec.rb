# frozen_string_literal: true
require "rails_helper"

RSpec.describe TasksController, type: :controller do
  fixtures :users, :participants

  let(:locale) { LOCALES.values.sample }
  let(:participant) do
    Participant.active.where.not(nurse: nil).find_by(locale: locale)
  end
  let(:nurse) { participant.nurse }
  let(:task) { instance_double(NurseTask).as_null_object }
  let(:tasks) { double("NurseTasks").as_null_object }

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
    allow(NurseTask).to receive(:for_nurse_and_participant)
      .with(nurse, participant)
      .and_return(tasks)
  end

  describe "GET index" do
    context "for an unauthenticated request" do
      before { get :index, participant_id: participant.id, locale: locale }

      it_behaves_like "a rejected user action"
    end

    context "for an authenticated nurse" do
      context "when the Participant isn't found" do
        before do
          sign_in_user nurse

          get :index, participant_id: -1, locale: locale
        end

        it_behaves_like "a bad request"
      end

      it "sets the tasks" do
        authorize_nurse
        stub_tasks

        get :index, participant_id: participant.id, locale: locale

        expect(assigns(:tasks).tasks).to eq(tasks)
      end
    end
  end

  describe "PUT resolve" do
    context "for an unauthenticated request" do
      before do
        put :resolve, participant_id: participant.id, locale: locale, id: rand
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

          put :resolve, participant_id: -1, locale: locale, id: rand
        end

        it_behaves_like "a bad request"
      end

      context "when the Task isn't found" do
        before do
          sign_in_user nurse

          put :resolve, participant_id: participant.id, locale: locale, id: -1
        end

        it_behaves_like "a bad request"
      end

      it "updates the task's status" do
        authorize_nurse
        stub_task

        put :resolve, participant_id: participant.id, locale: locale, id: rand

        expect(task).to have_received(:resolve)
      end

      context "when successful" do
        it "sets the flash notice" do
          authorize_nurse
          stub_task
          allow(task).to receive(:resolve) { true }

          put :resolve, participant_id: participant.id, locale: locale, id: rand

          expect(flash[:notice]).not_to be_blank
        end
      end

      context "when unsuccessful" do
        it "sets the flash alert" do
          authorize_nurse
          stub_task
          allow(task).to receive(:resolve) { false }
          allow(task).to receive_message_chain("errors.full_messages")

          put :resolve, participant_id: participant.id, locale: locale, id: rand

          expect(flash[:alert]).not_to be_blank
        end
      end

      it "redirects to the tasks page" do
        authorize_nurse
        stub_tasks
        allow(tasks).to receive(:find) { task }

        put :resolve, participant_id: participant.id, locale: locale, id: rand

        expect(response).to redirect_to participant_tasks_url(participant)
      end
    end
  end
end
