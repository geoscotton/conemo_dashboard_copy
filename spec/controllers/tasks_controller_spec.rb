# frozen_string_literal: true
require "rails_helper"

RSpec.describe TasksController, type: :controller do
  fixtures :all

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
    allow(NurseTask).to receive(:for_participant)
      .with(participant)
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

  describe "POST notify_supervisor" do
    context "for an unauthenticated request" do
      before do
        post :notify_supervisor,
             participant_id: participant.id, locale: locale, id: rand
      end

      it_behaves_like "a rejected user action"
    end

    context "for an authenticated nurse" do
      let(:notification) { instance_double(SupervisorNotification) }

      def stub_task
        stub_tasks
        allow(tasks).to receive(:find) { task }
      end

      def stub_notification(does_save)
        allow(SupervisorNotification).to receive(:new) { notification }
        allow(notification).to receive(:save) { does_save }
      end

      context "when the Participant isn't found" do
        before do
          sign_in_user nurse

          post :notify_supervisor,
               participant_id: -1, locale: locale, id: rand
        end

        it_behaves_like "a bad request"
      end

      context "when the Task isn't found" do
        before do
          sign_in_user nurse

          post :notify_supervisor,
               participant_id: participant.id, locale: locale, id: -1
        end

        it_behaves_like "a bad request"
      end

      it "creates a notification" do
        authorize_nurse
        stub_task
        stub_notification true

        post :notify_supervisor,
             participant_id: participant.id, locale: locale, id: rand

        expect(SupervisorNotification)
          .to have_received(:new)
          .with(nurse_task: task)
      end

      context "when successful" do
        it "sets the flash notice" do
          authorize_nurse
          stub_task
          stub_notification true

          post :notify_supervisor,
               participant_id: participant.id, locale: locale, id: rand

          expect(flash[:notice]).not_to be_blank
        end

        it "redirects to the tasks page" do
          authorize_nurse
          stub_task
          stub_notification true

          post :notify_supervisor,
               participant_id: participant.id, locale: locale, id: rand

          expect(response).to redirect_to participant_tasks_url(participant)
        end
      end

      context "when unsuccessful" do
        it "sets the flash alert" do
          authorize_nurse
          stub_task
          stub_notification false
          allow(notification)
            .to receive_message_chain("errors.full_messages")
            .and_return([])

          post :notify_supervisor,
               participant_id: participant.id, locale: locale, id: rand

          expect(flash[:alert]).not_to be_blank
        end

        it "redirects to the tasks page" do
          authorize_nurse
          stub_task
          stub_notification false
          allow(notification)
            .to receive_message_chain("errors.full_messages")
            .and_return([])

          post :notify_supervisor,
               participant_id: participant.id, locale: locale, id: rand

          expect(response).to redirect_to participant_tasks_url(participant)
        end
      end
    end
  end

  describe "DELETE clear_latest_supervisor_notification" do
    context "for an unauthenticated request" do
      before do
        delete :clear_latest_supervisor_notification,
               participant_id: participant.id, locale: locale, id: rand
      end

      it_behaves_like "a rejected user action"
    end

    context "for an authenticated nurse" do
      let(:notification) { instance_double(SupervisorNotification) }

      def stub_task
        stub_tasks
        allow(tasks).to receive(:find) { task }
      end

      def stub_notification(does_destroy)
        allow(SupervisorNotification).to receive(:latest_for) { notification }
        allow(notification).to receive(:destroy) { does_destroy }
      end

      context "when the Participant isn't found" do
        before do
          sign_in_user nurse

          delete :clear_latest_supervisor_notification,
                 participant_id: -1, locale: locale, id: rand
        end

        it_behaves_like "a bad request"
      end

      context "when the Task isn't found" do
        before do
          sign_in_user nurse

          delete :clear_latest_supervisor_notification,
                 participant_id: participant.id, locale: locale, id: -1
        end

        it_behaves_like "a bad request"
      end

      it "destroys a notification" do
        authorize_nurse
        stub_task
        stub_notification true

        delete :clear_latest_supervisor_notification,
               participant_id: participant.id, locale: locale, id: rand

        expect(notification).to have_received(:destroy)
      end

      context "when successful" do
        it "sets the flash notice" do
          authorize_nurse
          stub_task
          stub_notification true

          delete :clear_latest_supervisor_notification,
                 participant_id: participant.id, locale: locale, id: rand

          expect(flash[:notice]).not_to be_blank
        end

        it "redirects to the tasks page" do
          authorize_nurse
          stub_task
          stub_notification true

          delete :clear_latest_supervisor_notification,
                 participant_id: participant.id, locale: locale, id: rand

          expect(response).to redirect_to participant_tasks_url(participant)
        end
      end

      context "when unsuccessful" do
        it "sets the flash alert" do
          authorize_nurse
          stub_task
          stub_notification false
          allow(notification)
            .to receive_message_chain("errors.full_messages")
            .and_return([])

          delete :clear_latest_supervisor_notification,
                 participant_id: participant.id, locale: locale, id: rand

          expect(flash[:alert]).not_to be_blank
        end

        it "redirects to the tasks page" do
          authorize_nurse
          stub_task
          stub_notification false
          allow(notification)
            .to receive_message_chain("errors.full_messages")
            .and_return([])

          delete :clear_latest_supervisor_notification,
                 participant_id: participant.id, locale: locale, id: rand

          expect(response).to redirect_to participant_tasks_url(participant)
        end
      end
    end
  end

  describe "GET edit" do
    context "for an unauthenticated User" do
      before do
        get :edit, id: rand, participant_id: participant.id, locale: locale
      end

      it_behaves_like "a rejected user action"
    end

    context "for an authenticated User" do
      context "when the Participant isn't found" do
        before do
          sign_in_user nurse

          get :edit, id: rand, participant_id: -1, locale: locale
        end

        it_behaves_like "a bad request"
      end

      it "sets the participant" do
        sign_in_user nurse
        allow(NurseTask).to receive(:find)

        get :edit, participant_id: participant.id, locale: locale, id: rand

        expect(assigns(:participant)).to eq participant
      end

      it "sets the task" do
        sign_in_user nurse
        allow(NurseTask).to receive(:find) { task }

        get :edit, participant_id: participant.id, locale: locale, id: rand

        expect(assigns(:task)).to eq task
      end
    end
  end

  describe "PUT update" do
    context "for an unauthenticated User" do
      before { put :update, id: rand, participant_id: participant.id }

      it_behaves_like "a rejected user action"
    end

    context "for an authenticated User" do
      context "when the Participant isn't found" do
        before do
          sign_in_user nurse

          put :update, id: rand, participant_id: -1, locale: locale
        end

        it_behaves_like "a bad request"
      end

      context "when the update fails" do
        it "renders the new template" do
          sign_in_user nurse
          allow(NurseTask).to receive(:find) { task }
          allow(task).to receive(:update) { true }
          allow(controller).to receive(:authorize!)

          put :update, id: rand, participant_id: participant.id, locale: locale,
                       task: { scheduled_at: nil }

          expect(response).to redirect_to participant_tasks_url(participant)
        end
      end

      it "redirects to the tasks page" do
        sign_in_user nurse
        allow(NurseTask).to receive(:find) { task }
        allow(task).to receive(:update) { true }
        allow(controller).to receive(:authorize!)

        put :update, id: rand, participant_id: participant.id, locale: locale,
                     task: { scheduled_at: Time.zone.now }

        expect(response).to redirect_to participant_tasks_url(participant)
      end
    end
  end
end
