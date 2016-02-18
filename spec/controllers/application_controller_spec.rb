require "spec_helper"

RSpec.describe ApplicationController, type: :controller do
  controller do
    def index
      render text: "Hi"
    end
  end

  let(:locale) { LOCALES.values.sample }

  describe "the locale" do
    context "when not provided" do
      it "reverts to the default" do
        get :index

        expect(I18n.locale).to eq I18n.default_locale
      end
    end

    context "when passed via parameter" do
      it "is assigned based on the parameter" do
        get :index, locale: locale

        expect(I18n.locale.to_s).to eq locale
      end
    end

    context "when there is an authenticated user" do
      it "is assigned based on the nurse's locale" do
        nurse_request :get, :index, locale

        expect(I18n.locale.to_s).to eq locale
        expect(response).to redirect_to root_path(locale: locale)
      end

      it "is assigned based on the admin's locale" do
        admin_request :get, :index, locale

        expect(I18n.locale.to_s).to eq locale
        expect(response).to redirect_to root_path(locale: locale)
      end
    end
  end
end
