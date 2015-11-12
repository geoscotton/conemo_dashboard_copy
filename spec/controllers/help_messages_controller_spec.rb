require "spec_helper"

RSpec.describe HelpMessagesController, type: :controller do
  fixtures :all

  let(:participant) { Participant.first }

  let(:help_message) { HelpMessage.first }

  describe "PUT update" do
    context "for unauthenticated requests" do
      before do
        put :update, participant_id: participant.id, id: help_message.id
      end

      it_behaves_like "a rejected user action"
    end
  end
end
