require "spec_helper"

module Active
  describe ParticipantsController, type: :controller do
    fixtures :all

    let(:locale) { LOCALES.values.sample }

    describe "GET index" do
      context "for authenticated requests" do
        it "should render the index page" do
          admin_request :get, :index, locale, locale: locale

          expect(response).to render_template :index
        end

        context "when the User is an admin" do
          it "sets participants not scoped by User" do
            admin_request :get, :index, locale, locale: locale

            expect(assigns(:participants).count)
              .to eq Participant.where(locale: locale).active.count
          end
        end

        context "when the User is not an admin" do
          it "sets participants scoped by User" do
            nurse = sign_in_nurse(locale)
            participants = Participant.where(locale: locale)
            allow(nurse).to receive(:active_participants)
              .and_return(participants)

            nurse_request :get, :index, locale, locale: locale

            expect(assigns(:participants).count)
              .to eq participants.count
          end
        end
      end
    end

    describe "GET show" do
      it "sets the participant" do
        participant = Participant.where(locale: locale).first

        admin_request :get, :show, locale, id: participant.id, locale: locale

        expect(assigns(:participant)).to eq participant
      end
    end
  end
end
