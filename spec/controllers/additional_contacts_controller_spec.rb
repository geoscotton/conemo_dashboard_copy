# frozen_string_literal: true
require "rails_helper"

RSpec.describe AdditionalContactsController, type: :controller do
  fixtures :participants

  let(:locale) { LOCALES.values.sample }
  let(:participant) do
    Participant.active.where.not(nurse: nil).find_by(locale: locale)
  end

  shared_examples "a bad request" do
    it do
      expect(response).to redirect_to nurse_dashboard_url(participant.nurse)
    end
  end

  def authorize_nurse
    sign_in_user participant.nurse
    allow(controller).to receive(:authorize!)
  end

  describe "GET new" do
    context "for an unauthenticated request" do
      before { get :new, participant_id: participant.id, locale: locale }

      it_behaves_like "a rejected user action"
    end

    context "for an authenticated nurse" do
      context "when the Participant isn't found" do
        before do
          authorize_nurse

          get :new, participant_id: -1, locale: locale
        end

        it_behaves_like "a bad request"
      end

      it "sets the additional_contact" do
        authorize_nurse

        get :new, participant_id: participant.id, locale: locale

        expect(assigns(:additional_contact))
          .to be_instance_of AdditionalContact
        expect(assigns(:additional_contact).participant)
          .to eq participant
      end
    end
  end

  describe "POST create" do
    let(:valid_params) do
      { scheduled_at: Time.zone.now, kind: "foobar" }
    end
    let(:invalid_params) do
      { scheduled_at: nil, kind: nil }
    end

    context "for an unauthenticated request" do
      before { post :create, participant_id: participant.id, locale: locale }

      it_behaves_like "a rejected user action"
    end

    context "for an authenticated nurse" do
      context "when successful" do
        it "creates a new AdditionalContact" do
          expect do
            authorize_nurse

            post :create, participant_id: participant.id,
                          additional_contact: valid_params,
                          locale: locale
          end.to change {
            AdditionalContact.where(participant: participant).count
          }.by(1)
        end

        it "redirects to the participant_tasks_path" do
          authorize_nurse

          post :create, participant_id: participant.id, locale: locale,
                        additional_contact: valid_params

          expect(response).to redirect_to participant_tasks_path(participant)
        end
      end

      context "when unsuccessful" do
        it "sets the flash alert" do
          authorize_nurse

          post :create, participant_id: participant.id, locale: locale,
                        additional_contact: invalid_params

          expect(flash[:alert]).not_to be_nil
        end

        it "renders the new template" do
          authorize_nurse

          post :create, participant_id: participant.id, locale: locale,
                        additional_contact: invalid_params

          expect(response).to render_template :new
        end
      end
    end
  end
end
