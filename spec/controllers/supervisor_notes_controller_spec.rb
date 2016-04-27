# frozen_string_literal: true
require "rails_helper"

RSpec.describe SupervisorNotesController, type: :controller do
  fixtures :all

  let(:valid_attributes) do
    { note: "some note" }
  end
  let(:invalid_attributes) do
    { note: nil }
  end
  let(:valid_session) { { nurse_id: nurse.id } }
  let(:locale) { LOCALES.values.sample }
  let(:nurse) do
    Nurse.find_by(locale: locale)
  end
  let(:nurse_supervisor) { nurse.nurse_supervisor }
  let!(:supervisor_note) do
    SupervisorNote.create! valid_attributes.merge(nurse: nurse)
  end

  describe "GET #new" do
    it "assigns a new supervisor_note as @supervisor_note" do
      sign_in_user nurse_supervisor

      get :new, nurse_id: nurse.id, locale: locale

      expect(assigns(:supervisor_note)).to be_a_new(SupervisorNote)
    end
  end

  describe "GET #edit" do
    it "assigns the requested supervisor_note as @supervisor_note" do
      sign_in_user nurse_supervisor

      get :edit, id: supervisor_note.to_param, nurse_id: nurse.id,
                 locale: locale

      expect(assigns(:supervisor_note)).to eq(supervisor_note)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new SupervisorNote" do
        sign_in_user nurse_supervisor

        expect do
          post :create, nurse_id: nurse.id, locale: locale,
                        supervisor_note: valid_attributes
        end.to change(SupervisorNote, :count).by(1)
      end

      it "assigns a newly created supervisor_note as @supervisor_note" do
        sign_in_user nurse_supervisor

        post :create, nurse_id: nurse.id, locale: locale,
                      supervisor_note: valid_attributes

        expect(assigns(:supervisor_note)).to be_a(SupervisorNote)
        expect(assigns(:supervisor_note)).to be_persisted
      end

      it "redirects to the created supervisor_note" do
        sign_in_user nurse_supervisor

        post :create, nurse_id: nurse.id, locale: locale,
                      supervisor_note: valid_attributes

        expect(response).to redirect_to(nurse_supervision_sessions_url(nurse))
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved supervisor_note as @supervisor_note" do
        sign_in_user nurse_supervisor

        post :create, nurse_id: nurse.id, locale: locale,
                      supervisor_note: invalid_attributes

        expect(assigns(:supervisor_note)).to be_a_new(SupervisorNote)
      end

      it "re-renders the 'new' template" do
        sign_in_user nurse_supervisor

        post :create, nurse_id: nurse.id, locale: locale,
                      supervisor_note: invalid_attributes

        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) do
        { note: "some other note" }
      end

      it "updates the requested supervisor_note" do
        sign_in_user nurse_supervisor

        put :update, id: supervisor_note.to_param,
                     nurse_id: nurse.id, locale: locale,
                     supervisor_note: new_attributes
        supervisor_note.reload

        expect(supervisor_note.note).to eq "some other note"
      end

      it "assigns the requested supervisor_note as @supervisor_note" do
        sign_in_user nurse_supervisor

        put :update, id: supervisor_note.to_param,
                     nurse_id: nurse.id, locale: locale,
                     supervisor_note: new_attributes

        expect(assigns(:supervisor_note)).to eq(supervisor_note)
      end

      it "redirects to the supervisor_note" do
        sign_in_user nurse_supervisor

        put :update, id: supervisor_note.to_param,
                     nurse_id: nurse.id, locale: locale,
                     supervisor_note: new_attributes

        expect(response).to redirect_to(active_report_url(nurse))
      end
    end

    context "with invalid params" do
      it "assigns the supervisor_note as @supervisor_note" do
        sign_in_user nurse_supervisor

        put :update, id: supervisor_note.to_param,
                     nurse_id: nurse.id, locale: locale,
                     supervisor_note: invalid_attributes

        expect(assigns(:supervisor_note)).to eq(supervisor_note)
      end

      it "re-renders the 'edit' template" do
        sign_in_user nurse_supervisor

        put :update, id: supervisor_note.to_param,
                     nurse_id: nurse.id, locale: locale,
                     supervisor_note: invalid_attributes

        expect(response).to render_template("edit")
      end
    end
  end
end
