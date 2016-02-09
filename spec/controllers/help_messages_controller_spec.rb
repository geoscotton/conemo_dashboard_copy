require "spec_helper"

RSpec.describe HelpMessagesController, type: :controller do
  fixtures :all

  let(:locale) { LOCALES.values.sample }
  let(:participant) { Participant.find_by(locale: locale) }

  let(:help_message) { HelpMessage.first }

  let(:valid_help_message_params) { { read: true } }

  let(:invalid_help_message_params) { { read: nil } }

  describe "PUT update" do
    context "for unauthenticated requests" do
      before do
        put :update, participant_id: participant.id, id: help_message.id
      end

      it_behaves_like "a rejected user action"
    end

    context "for authenticated requests" do
      context "when the participant is not found" do
        it "redirects to active participants" do
          admin_request :put, :update, locale, participant_id: -1,
                        id: help_message.id,
                        help_message: valid_help_message_params

          expect(response).to redirect_to active_participants_url
        end
      end

      context "when successful" do
        it "updates the help message" do
          expect do
            admin_request :put, :update, locale, participant_id: participant.id,
                          id: help_message.id,
                          help_message: valid_help_message_params
          end.to change { HelpMessage.find(help_message.id).updated_at }
        end

        it "redirects to the active report" do
          admin_request :put, :update, locale, participant_id: participant.id,
                        id: help_message.id,
                        help_message: valid_help_message_params

          expect(response).to redirect_to active_report_path(participant)
        end
      end

      context "when unsuccessful" do
        it "sets the flash alert" do
          admin_request :put, :update, locale, participant_id: participant.id,
                        id: help_message.id,
                        help_message: invalid_help_message_params

          expect(flash[:alert]).not_to be_nil
        end

        it "redirects to the active report" do
          admin_request :put, :update, locale, participant_id: participant.id,
                        id: help_message.id,
                        help_message: invalid_help_message_params

          expect(response).to redirect_to active_report_path(participant)
        end
      end
    end
  end
end
