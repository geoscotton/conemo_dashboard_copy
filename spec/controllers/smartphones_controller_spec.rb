require "spec_helper"

RSpec.describe SmartphonesController, type: :controller do
  fixtures :all

  let(:participant) { Participant.first }

  let(:valid_smartphone_params) { { number: "1" } }

  let(:invalid_smartphone_params) { { number: nil } }

  shared_examples "a bad request" do
    it { expect(response).to redirect_to active_participants_url }
  end

  def admin_request(http_method, action, params)
    sign_in_admin

    send http_method, action, params
  end

  describe "GET new" do
    context "for an unauthenticated request" do
      before { get :new, participant_id: participant.id }

      it_behaves_like "a rejected user action"
    end

    context "for an authenticated User" do
      context "when the Participant isn't found" do
        before { admin_request :get, :new, participant_id: -1 }

        it_behaves_like "a bad request"
      end

      it "sets smartphone" do
        admin_request :get, :new, participant_id: participant.id

        expect(assigns(:smartphone)).to be_instance_of Smartphone
        expect(assigns(:smartphone).participant).to eq participant
      end
    end
  end

  describe "POST create" do
    context "for an unauthenticated request" do
      before { post :create, participant_id: participant.id }

      it_behaves_like "a rejected user action"
    end

    context "for an authenticated User" do
      context "when the Participant isn't found" do
        before { admin_request :post, :create, participant_id: -1 }

        it_behaves_like "a bad request"
      end

      context "when successful" do
        it "creates a new Smartphone" do
          expect do
            admin_request :post, :create, participant_id: participant.id,
                          smartphone: valid_smartphone_params
          end.to change { Smartphone.where(participant: participant).count }
            .by(1)
        end

        it "redirects to active_participants_path" do
          admin_request :post, :create, participant_id: participant.id,
                        smartphone: valid_smartphone_params

          expect(response).to redirect_to active_participants_path
        end
      end

      context "when unsuccessful" do
        it "sets the flash alert" do
          admin_request :post, :create, participant_id: participant.id,
                        smartphone: invalid_smartphone_params

          expect(flash[:alert]).not_to be_nil
        end

        it "renders the new template" do
          admin_request :post, :create, participant_id: participant.id,
                        smartphone: invalid_smartphone_params

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
        before { admin_request :get, :edit, participant_id: -1 }

        it_behaves_like "a bad request"
      end

      it "sets smartphone" do
        participant.create_smartphone valid_smartphone_params

        admin_request :get, :edit, participant_id: participant.id,
                      smartphone: invalid_smartphone_params

        expect(assigns(:smartphone)).to be_instance_of Smartphone
        expect(assigns(:smartphone).participant).to eq participant
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
        before { admin_request :put, :update, participant_id: -1 }

        it_behaves_like "a bad request"
      end

      context "when successful" do
        it "redirects to active_participant_path" do
          participant.create_smartphone valid_smartphone_params

          admin_request :put, :update, participant_id: participant.id,
                        smartphone: valid_smartphone_params

          expect(response).to redirect_to active_participant_path(participant)
        end
      end

      context "when unsuccessful" do
        it "sets the flash alert" do
          participant.create_smartphone valid_smartphone_params

          admin_request :put, :update, participant_id: participant.id,
                        smartphone: invalid_smartphone_params

          expect(flash[:alert]).not_to be_nil
        end

        it "renders the edit template" do
          participant.create_smartphone valid_smartphone_params

          admin_request :put, :update, participant_id: participant.id,
                        smartphone: invalid_smartphone_params

          expect(response).to render_template :edit
        end
      end
    end
  end
end
