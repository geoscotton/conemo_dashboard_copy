# frozen_string_literal: true
require "spec_helper"

RSpec.describe TasksController, type: :controller do
  fixtures :participants

  let(:locale) { LOCALES.values.sample }
  let(:participant) { Participant.active.find_by(locale: locale) }

  shared_examples "a bad request" do
    it do
      expect(response).to redirect_to active_participants_url(locale: locale)
    end
  end

  def authorize_nurse
    allow(controller).to receive(:authorize!)

    sign_in_nurse locale
  end

  describe "GET index" do
    context "for an unauthenticated request" do
      before { get :index, participant_id: participant.id, locale: locale }

      it_behaves_like "a rejected user action"
    end

    context "for an authenticated nurse" do
      context "when the Participant isn't found" do
        before do
          authorize_nurse

          get :index, participant_id: -1, locale: locale
        end

        it_behaves_like "a bad request"
      end

      it "sets the tasks" do
        task = instance_double(NurseTask)
        nurse = authorize_nurse
        allow(NurseTask).to receive(:for_nurse_and_participant)
          .with(nurse, participant)
          .and_return([task])

        get :index, participant_id: participant.id, locale: locale

        expect(assigns(:tasks)).to eq([task])
      end
    end
  end
end
