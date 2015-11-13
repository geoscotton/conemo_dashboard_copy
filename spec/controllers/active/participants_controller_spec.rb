require "spec_helper"

module Active
  describe ParticipantsController, type: :controller do
    LOCALES = %w( en es-PE pt-BR )

    fixtures :all

    let(:participant) { Participant.first }

    describe "GET index" do
      context "for authenticated requests" do
        it "should render the index page" do
          admin_request :get, :index

          expect(response).to render_template :index
        end

        context "when the User is an admin" do
          it "sets participants not scoped by User" do
            LOCALES.each do |locale|
              admin_request :get, :index, locale: locale

              expect(assigns(:participants).count)
                .to eq Participant.where(locale: locale).active.count
            end
          end
        end

        context "when the User is not an admin" do
          it "sets participants scoped by User" do
            nurse = sign_in_nurse
            participants = Participant.where(locale: nurse.locale)
            allow(nurse).to receive(:active_participants)
              .and_return(participants)

            nurse_request :get, :index, locale: nurse.locale

            expect(assigns(:participants).count)
              .to eq participants.count
          end
        end
      end
    end

    describe "GET show" do
      it "sets the participant" do
        admin_request :get, :show, id: participant.id

        expect(assigns(:participant)).to eq participant
      end
    end
  end
end
