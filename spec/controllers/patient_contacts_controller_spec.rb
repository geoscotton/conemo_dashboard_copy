# frozen_string_literal: true
require "rails_helper"

RSpec.describe PatientContactsController, type: :controller do
  fixtures :all

  let(:locale) { LOCALES.values.sample }
  let(:participant) do
    Participant.where.not(nurse: nil).find_by(locale: locale)
  end
  let(:nurse) { participant.nurse }
  let(:valid_patient_contact_params) { { contact_at: Time.zone.now } }

  shared_examples "a bad request" do
    it do
      expect(response).to redirect_to nurse_dashboard_url(nurse)
    end
  end

  describe "GET new" do
    context "for an unauthenticated request" do
      before { get :new, participant_id: participant.id, locale: locale }

      it_behaves_like "a rejected user action"
    end

    context "for an authenticated user" do
      context "when the Participant isn't found" do
        before do
          sign_in_user nurse
          get :new, participant_id: -1, locale: locale
        end

        it_behaves_like "a bad request"
      end

      it "sets patient contact" do
        admin_request :get, :new, locale,
                      participant_id: participant.id, locale: locale

        expect(assigns(:patient_contact)).to be_instance_of PatientContact
        expect(assigns(:patient_contact).participant).to eq participant
      end
    end
  end

  describe "POST create" do
    context "for an unauthenticated request" do
      before { post :create, participant_id: participant.id }

      it_behaves_like "a rejected user action"
    end

    context "for an authenticated user" do
      context "when the Participant isn't found" do
        before do
          sign_in_user nurse
          post :create,
               participant_id: -1, locale: locale,
               patient_contact: valid_patient_contact_params
        end

        it_behaves_like "a bad request"
      end

      context "when successful" do
        it "creates a patient contact" do
          expect do
            admin_request :post, :create, locale, participant_id: participant.id,
                                                  patient_contact: valid_patient_contact_params,
                                                  locale: locale
          end.to change { PatientContact.where(participant: participant).count }
            .by(1)
        end

        it "redirects to the active report path" do
          admin_request :post, :create, locale,
                        participant_id: participant.id, locale: locale,
                        patient_contact: valid_patient_contact_params

          expect(response).to redirect_to active_report_path(participant)
        end
      end
    end
  end

  describe "DELETE destroy" do
    context "for an unauthenticated request" do
      before { delete :destroy, participant_id: participant.id, id: 1 }

      it_behaves_like "a rejected user action"
    end

    context "for an authenticated user" do
      context "when the Participant isn't found" do
        before do
          sign_in_user nurse
          delete :destroy, participant_id: -1, id: 1, locale: locale
        end

        it_behaves_like "a bad request"
      end

      context "when successful" do
        it "destroys a patient contact record" do
          patient_contact = participant.patient_contacts.create(
            valid_patient_contact_params
          )

          expect do
            admin_request(:delete,
                          :destroy,
                          locale,
                          participant_id: participant,
                          id: patient_contact.id, locale: locale)
          end.to change {
            PatientContact.where(participant: participant).count
          }.by(-1)
        end

        it "redirects to the active report path" do
          patient_contact = participant.patient_contacts.create(
            valid_patient_contact_params
          )

          admin_request :delete, :destroy, locale,
                        participant_id: participant.id,
                        id: patient_contact.id,
                        locale: locale

          expect(response).to redirect_to active_report_path(participant)
        end

        context "when unsuccessful" do
          it "sets the flash alert" do
            patient_contact = instance_double(PatientContact,
                                              id: 1,
                                              destroy: false)
            allow(PatientContact).to receive(:find) { patient_contact }

            admin_request(:delete,
                          :destroy,
                          locale,
                          participant_id: participant,
                          id: patient_contact.id, locale: locale)

            expect(flash[:alert]).not_to be_nil
          end
        end
      end
    end
  end
end
