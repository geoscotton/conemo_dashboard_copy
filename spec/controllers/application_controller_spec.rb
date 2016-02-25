require "spec_helper"

RSpec.describe ApplicationController, type: :controller do
  let(:locale) { LOCALES.values.sample }

  describe "the locale" do
    controller do
      def index
      end
    end

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

  describe "authorization" do
    context "when there is an authenticated user" do
      context "and she attempts an unauthorized request" do
        controller do
          def index
            raise CanCan::AccessDenied
          end
        end

        it "redirects to the root URL" do
          nurse_request :get, :index, locale, locale: locale

          expect(response).to redirect_to root_path(locale: locale)
        end

        it "sets the alert" do
          nurse_request :get, :index, locale, locale: locale

          expect(flash[:alert]).not_to be_nil
        end
      end
    end
  end
end
