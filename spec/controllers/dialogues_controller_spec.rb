require "spec_helper"

RSpec.describe DialoguesController, type: :controller do
  LOCALES = %w( en pt-BR es-PE )

  def create_dialogue!(locale)
    Dialogue.create!(locale: locale, title: "t", day_in_treatment: 1,
                     guid: "g", message: "m", yes_text: "y", no_text: "n")
  end

  def sign_in_nurse_for(locale)
    sign_in_user instance_double(User,
                                 nurse?: true,
                                 locale: locale,
                                 timezone: "America/Chicago")
  end

  def authorize!
    allow(controller).to receive(:authorize!)
  end

  let(:valid_dialogue_params) do
    { title: "t", day_in_treatment: 1, message: "m", yes_text: "y",
      no_text: "n" }
  end

  describe "GET index" do
    context "for an authorized User" do
      it "sets dialogs" do
        allow(controller).to receive(:authorize!).with(:index, Dialogue)

        LOCALES.each do |locale|
          sign_in_nurse_for locale
          dialogue = create_dialogue!(locale)

          get :index, locale: locale

          expect(assigns(:dialogues)).to eq([dialogue])
        end
      end
    end
  end

  describe "GET show" do
    context "for an authorized User" do
      it "sets the dialog" do
        LOCALES.each do |locale|
          sign_in_nurse_for locale
          dialogue = create_dialogue!(locale)
          allow(controller).to receive(:authorize!).with(:show, dialogue)

          get :show, id: dialogue.id, locale: locale

          expect(assigns(:dialogue)).to eq dialogue
        end
      end
    end
  end

  describe "GET new" do
    context "for an authorized User" do
      it "sets the dialog" do
        authorize!

        LOCALES.each do |locale|
          sign_in_nurse_for locale

          get :new, locale: locale

          expect(assigns(:dialogue)).to be_instance_of Dialogue
        end
      end
    end
  end

  describe "POST create" do
    context "for an authorized User" do
      context "when successful" do
        it "redirects to the dialogues index" do
          authorize!

          LOCALES.each do |locale|
            sign_in_nurse_for locale

            post :create, locale: locale, dialogue: valid_dialogue_params

            expect(assigns(:dialogue)).to be_an_instance_of Dialogue
            expect(response).to redirect_to dialogues_url
          end
        end
      end

      context "when not successful" do
        it "renders the new page" do
          authorize!

          LOCALES.each do |locale|
            sign_in_nurse_for locale

            post :create, locale: locale, dialogue: { foo: "baz" }

            expect(assigns(:dialogue)).to be_an_instance_of Dialogue
            expect(response).to render_template :new
          end
        end
      end
    end
  end

  describe "GET edit" do
    context "for an authorized User" do
      it "sets the dialog" do
        authorize!

        LOCALES.each do |locale|
          sign_in_nurse_for locale
          dialogue = create_dialogue!(locale)

          get :edit, id: dialogue.id, locale: locale

          expect(assigns(:dialogue)).to eq dialogue
        end
      end
    end
  end

  describe "PUT update" do
    context "for an authorized User" do
      context "when successful" do
        it "redirects to the dialogues index" do
          authorize!

          LOCALES.each do |locale|
            sign_in_nurse_for locale
            dialogue = create_dialogue!(locale)

            put :update, id: dialogue.id, locale: locale,
                dialogue: valid_dialogue_params

            expect(assigns(:dialogue)).to eq dialogue
            expect(response).to redirect_to dialogues_url
          end
        end
      end

      context "when not successful" do
        it "renders the new page" do
          authorize!

          LOCALES.each do |locale|
            sign_in_nurse_for locale
            dialogue = create_dialogue!(locale)

            put :update, id: dialogue.id, locale: locale,
                dialogue: { title: nil }

            expect(assigns(:dialogue)).to eq dialogue
            expect(response).to render_template :edit
          end
        end
      end
    end
  end

  describe "DELETE destroy" do
    context "for an authorized User" do
      context "when successful" do
        it "redirects to the dialogues index" do
          authorize!

          LOCALES.each do |locale|
            sign_in_nurse_for locale
            dialogue = create_dialogue!(locale)

            delete :destroy, id: dialogue.id, locale: locale

            expect(response).to redirect_to dialogues_url
          end
        end
      end

      context "when not successful" do
        it "sets the flash alert" do
          authorize!

          LOCALES.each do |locale|
            sign_in_nurse_for locale
            dialogue = create_dialogue!(locale)
            allow(Dialogue).to receive_message_chain("where.find" => dialogue)
            allow(dialogue).to receive(:destroy) { false }

            delete :destroy, id: dialogue.id, locale: locale

            expect(flash[:alert]).not_to be_nil
          end
        end
      end
    end
  end
end
