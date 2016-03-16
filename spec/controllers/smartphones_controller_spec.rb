# frozen_string_literal: true
require "rails_helper"

RSpec.describe SmartphonesController, type: :controller do
  fixtures :users, :participants

  let(:locale) { LOCALES.values.sample }
  let(:participant) do
    Participant.active.where.not(nurse: nil).find_by(locale: locale)
  end
  let(:nurse) { participant.nurse }
  let(:valid_smartphone_params) { { number: "1", phone_identifier: "321" } }
  let(:invalid_smartphone_params) { { number: nil, phone_identifier: nil } }

  shared_examples "a bad request" do
    it do
      expect(response).to redirect_to nurse_dashboard_url(nurse)
    end
  end

  describe "GET new" do
    context "for an unauthenticated request" do
      before { get :new, participant_id: participant.id }

      it_behaves_like "a rejected user action" do
        let(:user_locale) { locale }
      end
    end

    context "for an authenticated User" do
      context "when the Participant isn't found" do
        before do
          sign_in_user nurse
          get :new, participant_id: -1, locale: locale
        end

        it_behaves_like "a bad request"
      end

      it "sets smartphone" do
        admin_request :get, :new, locale, participant_id: participant.id,
                                          locale: locale

        expect(assigns(:smartphone)).to be_instance_of Smartphone
        expect(assigns(:smartphone).participant).to eq participant
      end
    end
  end

  describe "POST create" do
    context "for an unauthenticated request" do
      before { post :create, participant_id: participant.id, locale: locale }

      it_behaves_like "a rejected user action" do
        let(:user_locale) { locale }
      end
    end

    context "for an authenticated User" do
      context "when the Participant isn't found" do
        before do
          sign_in_user nurse

          post :create, participant_id: -1, locale: locale
        end

        it_behaves_like "a bad request"
      end

      context "when successful" do
        it "creates a new Smartphone" do
          Smartphone.destroy_all

          expect do
            admin_request :post, :create, locale, participant_id: participant.id,
                                                  smartphone: valid_smartphone_params, locale: locale
          end.to change { Smartphone.where(participant: participant).count }
            .by(1)
        end

        it "redirects to participant tasks" do
          admin_request :post, :create, locale, participant_id: participant.id,
                                                smartphone: valid_smartphone_params,
                                                locale: locale

          expect(response).to redirect_to participant_tasks_url(participant)
        end
      end

      context "when unsuccessful" do
        it "sets the flash alert" do
          admin_request :post, :create, locale, participant_id: participant.id,
                                                smartphone: invalid_smartphone_params,
                                                locale: locale

          expect(flash[:alert]).not_to be_nil
        end

        it "renders the new template" do
          admin_request :post, :create, locale, participant_id: participant.id,
                                                smartphone: invalid_smartphone_params, locale: locale

          expect(response).to render_template :new
        end
      end
    end
  end

  describe "GET edit" do
    context "for an unauthenticated request" do
      before { get :edit, participant_id: participant.id }

      it_behaves_like "a rejected user action"
    end

    context "for an authenticated User" do
      context "when the Participant isn't found" do
        before do
          sign_in_user nurse

          get :edit, participant_id: -1, locale: locale
        end

        it_behaves_like "a bad request"
      end

      it "sets smartphone" do
        participant.create_smartphone valid_smartphone_params

        admin_request :get, :edit, locale, participant_id: participant.id,
                                           smartphone: invalid_smartphone_params, locale: locale

        expect(assigns(:smartphone)).to be_instance_of Smartphone
        expect(assigns(:smartphone).participant).to eq participant
      end
    end
  end

  describe "PUT update" do
    context "for an unauthenticated request" do
      before { put :update, participant_id: participant.id, locale: locale }

      it_behaves_like "a rejected user action" do
        let(:user_locale) { locale }
      end
    end

    context "for an authenticated User" do
      context "when the Participant isn't found" do
        before do
          sign_in_user nurse

          put :update, participant_id: -1, locale: locale
        end

        it_behaves_like "a bad request"
      end

      context "when successful" do
        it "redirects to active_participant_path" do
          participant.create_smartphone valid_smartphone_params

          admin_request :put, :update, locale, participant_id: participant.id,
                                               smartphone: valid_smartphone_params, locale: locale

          expect(response).to redirect_to active_participant_path(participant)
        end
      end

      context "when unsuccessful" do
        it "sets the flash alert" do
          participant.create_smartphone valid_smartphone_params

          admin_request :put, :update, locale, participant_id: participant.id,
                                               smartphone: invalid_smartphone_params, locale: locale

          expect(flash[:alert]).not_to be_nil
        end

        it "renders the edit template" do
          participant.create_smartphone valid_smartphone_params

          admin_request :put, :update, locale, participant_id: participant.id,
                                               smartphone: invalid_smartphone_params, locale: locale

          expect(response).to render_template :edit
        end
      end
    end
  end
end
