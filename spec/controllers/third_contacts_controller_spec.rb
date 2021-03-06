# frozen_string_literal: true
require "rails_helper"

RSpec.describe ThirdContactsController, type: :controller do
  fixtures :all

  let(:locale) { LOCALES.values.sample }
  let(:participant) do
    Participant.where.not(nurse: nil).find_by(locale: locale)
  end
  let(:nurse) { participant.nurse }
  let(:valid_third_contact_params) do
    {
      contact_at: Time.zone.now,
      session_length: "b",
      notes: "n",
      difficulties: %w( d1 d2 )
    }
  end
  let(:raw_params) do
    valid_third_contact_params.merge(
      patient_contacts_attributes: {
        "0": {
          contact_reason: "o",
          note: "p"
        }
      }
    )
  end
  let(:invalid_third_contact_params) do
    {
      contact_at: nil,
      session_length: nil
    }
  end

  shared_examples "a bad request" do
    it { expect(response).to redirect_to nurse_dashboard_url(nurse) }
  end

  describe ".filter_params" do
    it "permits expected parameters" do
      params = ActionController::Parameters.new(third_contact: raw_params)
      filtered_params = ThirdContactsController.filter_params(params)

      expect(filtered_params).to eq raw_params.with_indifferent_access
    end
  end

  describe "GET new" do
    context "for an unauthenticated request" do
      before { get :new, participant_id: participant.id, locale: locale }

      it_behaves_like "a rejected user action"
    end

    context "for an authenticated User" do
      context "when the Participant isn't found" do
        before do
          sign_in_user nurse
          get :new, participant_id: -1, locale: locale
        end

        it_behaves_like "a bad request"
      end

      it "sets the third_contact" do
        admin_request :get, :new, locale, participant_id: participant.id, locale: locale

        expect(assigns(:third_contact)).to be_instance_of ThirdContact
        expect(assigns(:third_contact).participant).to eq participant
      end

      it "does not destroy an existing appointment" do
        participant.create_third_contact(valid_third_contact_params)
        expect do
          nurse_request :get, :new, locale, participant_id: participant.id,
                                            locale: locale
        end.not_to change { ThirdContact.count }
      end
    end
  end

  describe "POST create" do
    context "for an unauthenticated request" do
      before { post :create, participant_id: participant.id }

      it_behaves_like "a rejected user action"
    end

    context "when authenticated" do
      context "when the Participant isn't found" do
        before do
          sign_in_user nurse
          post :create, participant_id: -1, locale: locale
        end

        it_behaves_like "a bad request"
      end

      context "when successful" do
        it "redirects to the participant tasks" do
          contact = instance_double("ThirdContact", save: true)
          allow(Participant).to receive(:find) { participant }

          expect(participant).to receive(:build_third_contact)
            .with(instance_of(ActionController::Parameters))
            .and_return(contact)

          admin_request :post, :create, locale,
                        participant_id: participant.id,
                        third_contact: { q1: "question 1" },
                        locale: locale

          expect(response).to redirect_to(participant_tasks_url(participant))
        end
      end

      context "when unsuccessful" do
        it "sets the flash alert" do
          admin_request :post, :create, locale, participant_id: participant.id,
                                                third_contact: invalid_third_contact_params,
                                                locale: locale

          expect(flash[:alert]).not_to be_nil
        end

        it "renders the new template" do
          admin_request :post, :create, locale, participant_id: participant.id,
                                                third_contact: invalid_third_contact_params,
                                                locale: locale

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

      it "sets third_contact" do
        participant.create_third_contact(valid_third_contact_params)

        admin_request :get, :edit, locale, participant_id: participant.id,
                                           locale: locale

        expect(assigns(:third_contact)).to be_instance_of ThirdContact
        expect(assigns(:third_contact).participant).to eq participant
      end
    end
  end

  describe "PUT update" do
    context "for an unauthenticated request" do
      before { put :update, participant_id: participant.id }

      it_behaves_like "a rejected user action"
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
        it "redirects to the active participant" do
          participant.create_third_contact(valid_third_contact_params)

          admin_request :put, :update, locale,
                        participant_id: participant.id, locale: locale,
                        third_contact: valid_third_contact_params

          expect(response).to redirect_to active_participant_url(participant)
        end
      end

      context "when unsuccessful" do
        it "sets the flash alert" do
          participant.create_third_contact(valid_third_contact_params)

          admin_request :put, :update, locale,
                        participant_id: participant.id, locale: locale,
                        third_contact: invalid_third_contact_params

          expect(flash[:alert]).not_to be_nil
        end

        it "renders the edit template" do
          participant.create_third_contact(valid_third_contact_params)

          admin_request :put, :update, locale,
                        participant_id: participant.id, locale: locale,
                        third_contact: invalid_third_contact_params

          expect(response).to render_template :edit
        end
      end
    end
  end
end
