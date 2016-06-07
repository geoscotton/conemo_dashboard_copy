# frozen_string_literal: true
require "rails_helper"

RSpec.describe ParticipantsController, type: :controller do
  fixtures :all

  let(:locale) { LOCALES.values.sample }
  let(:participant) { Participant.find_by(locale: locale) }

  let(:valid_participant_params) do
    { first_name: "f", last_name: "l", study_identifier: "1",
      family_health_unit_name: "u", address: "a",
      phone: "5555555555", gender: "male" }
  end

  let(:invalid_participant_params) do
    { first_name: nil, last_name: nil, study_identifier: nil,
      family_health_unit_name: nil,
      phone: nil }
  end

  describe "GET new" do
    context "for unauthenticated requests" do
      before { get :new }

      it_behaves_like "a rejected user action"
    end

    context "for authenticated requests" do
      it "sets the participant" do
        admin_request :get, :new, locale, locale: locale

        expect(assigns(:participant)).to be_instance_of Participant
      end
    end
  end

  describe "POST create" do
    context "for unauthenticated requests" do
      before { post :create }

      it_behaves_like "a rejected user action"
    end

    context "for authenticated requests" do
      context "when successful" do
        it "creates a Participant" do
          expect do
            admin_request :post, :create, locale,
                          participant: valid_participant_params,
                          locale: locale
          end.to change { Participant.where(locale: locale).count }.by(1)
        end

        it "redirects to pending_participants_path" do
          admin_request :post, :create, locale,
                        participant: valid_participant_params,
                        locale: locale

          expect(response).to redirect_to pending_participants_path
        end
      end

      context "when unsuccessful" do
        it "sets the flash alert" do
          admin_request :post, :create, locale,
                        participant: invalid_participant_params,
                        locale: locale

          expect(flash[:alert]).not_to be_nil
        end

        it "renders new" do
          admin_request :post, :create, locale,
                        participant: invalid_participant_params,
                        locale: locale

          expect(response).to render_template :new
        end
      end
    end
  end

  describe "GET edit" do
    context "for unauthenticated requests" do
      before { get :edit, id: participant.id }

      it_behaves_like "a rejected user action"
    end

    context "for authenticated requests" do
      it "sets the participant" do
        admin_request :get, :edit, locale, id: participant.id, locale: locale

        expect(assigns(:participant)).to eq participant
      end
    end
  end

  describe "PUT update" do
    context "for unauthenticated requests" do
      before { put :update, id: participant.id }

      it_behaves_like "a rejected user action"
    end

    context "for authenticated requests" do
      context "when successful" do
        it "updates the Participant" do
          expect do
            admin_request :put, :update, locale,
                          id: participant.id,
                          participant: valid_participant_params, locale: locale
          end.to change { Participant.find(participant.id).updated_at }
        end

        context "and the Participant is active" do
          it "redirects to pending participants" do
            participant.update status: Participant::ACTIVE

            admin_request :put, :update, locale,
                          id: participant.id,
                          participant: valid_participant_params, locale: locale

            expect(response).to redirect_to root_url(locale: locale)
          end
        end

        context "and the Participant is not active" do
          it "redirects to pending participants" do
            participant.update! status: [Participant::PENDING,
                                         Participant::COMPLETED].sample

            admin_request :put, :update, locale,
                          id: participant.id,
                          participant: valid_participant_params, locale: locale

            expect(response).to redirect_to root_url(locale: locale)
          end
        end
      end

      context "when unsuccessful" do
        it "sets the flash alert" do
          admin_request :put, :update, locale,
                        id: participant.id,
                        participant: invalid_participant_params, locale: locale

          expect(flash[:alert]).not_to be_nil
        end

        it "renders the edit template" do
          admin_request :put, :update, locale,
                        id: participant.id,
                        participant: invalid_participant_params, locale: locale

          expect(response).to render_template :edit
        end
      end
    end
  end
end
