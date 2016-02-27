# frozen_string_literal: true
require "rails_helper"

RSpec.describe LessonsController, type: :controller do
  fixtures :all

  let(:locale) { LOCALES.values.sample }
  let(:lesson) { Lesson.find_by(locale: locale) }
  let(:valid_lesson_params) do
    { title: "t", day_in_treatment: 1, locale: "pt-BR" }
  end
  let(:invalid_lesson_params) do
    { title: nil, day_in_treatment: nil, locale: nil }
  end

  describe "GET index" do
    context "for unauthenticated requests" do
      before { get :index, locale: locale }

      it_behaves_like "a rejected user action"
    end

    context "for authenticated requests" do
      it "renders the index template" do
        admin_request :get, :index, locale, locale: locale

        expect(response).to render_template :index
      end
    end
  end

  describe "GET show" do
    context "for unauthenticated requests" do
      before { get :show, id: 1 }
      it_behaves_like "a rejected user action"
    end

    context "for authenticated requests by admins or nurses" do
      context "when the lesson is found" do
        it "sets the lesson" do
          admin_request :get, :show, locale, id: lesson.id, locale: lesson.locale

          expect(assigns(:lesson)).to eq lesson
        end
      end
    end
  end

  describe "GET new" do
    context "for unauthenticated requests" do
      before { get :new }

      it_behaves_like "a rejected user action"
    end

    context "for authenticated requests by admins or nurses" do
      it "sets the lesson" do
        admin_request :get, :new, locale, locale: locale

        expect(assigns(:lesson)).to be_instance_of Lesson
        expect(assigns(:lesson).locale).to eq locale
      end
    end
  end

  describe "GET edit" do
    context "for unauthenticated requests" do
      before { get :edit, id: 1 }

      it_behaves_like "a rejected user action" do
        let(:user_locale) { locale }
      end
    end

    context "for authenticated requests by admins or nurses" do
      it "sets the lesson" do
        admin_request :get, :edit, locale, id: lesson.id, locale: lesson.locale

        expect(assigns(:lesson)).to eq lesson
      end
    end
  end

  describe "POST create" do
    context "for unauthenticated requests" do
      before { post :create }

      it_behaves_like "a rejected user action" do
        let(:user_locale) { locale }
      end
    end

    context "for authenticated requests by admins or nurses" do
      context "when successful" do
        it "creates a lesson" do
          expect do
            admin_request :post, :create, locale, lesson: valid_lesson_params,
                                                  locale: locale
          end.to change { Lesson.count }.by(1)
        end

        it "redirects to the lessons url" do
          admin_request :post, :create, locale, lesson: valid_lesson_params,
                                                locale: locale

          expect(response).to redirect_to lessons_url
        end
      end

      context "when unsuccessful" do
        it "renders the new template" do
          admin_request :post, :create, locale, lesson: invalid_lesson_params,
                                                locale: locale

          expect(response).to render_template :new
        end
      end
    end
  end

  describe "PUT update" do
    context "for unauthenticated requests" do
      before { put :update, id: 1 }

      it_behaves_like "a rejected user action" do
        let(:user_locale) { locale }
      end
    end

    context "for authenticated requests by admins or nurses" do
      context "when successful" do
        it "updates the lesson" do
          expect do
            admin_request :put, :update, locale, id: lesson.id, locale: lesson.locale,
                                                 lesson: valid_lesson_params
          end.to change { Lesson.find(lesson.id).updated_at }
        end

        it "redirects to the lessons url" do
          admin_request :put, :update, locale, id: lesson.id, locale: lesson.locale,
                                               lesson: valid_lesson_params

          expect(response).to redirect_to lessons_url(locale: lesson.locale)
        end
      end

      context "when unsuccessful" do
        it "renders the edit template" do
          admin_request :put, :update, locale, id: lesson.id, locale: lesson.locale,
                                               lesson: invalid_lesson_params

          expect(response).to render_template :edit
        end
      end
    end
  end

  describe "DELETE destroy" do
    context "for unauthenticated requests" do
      before { delete :destroy, id: 1 }

      it_behaves_like "a rejected user action" do
        let(:user_locale) { locale }
      end
    end

    context "for authenticated requests by admins or nurses" do
      before { ContentAccessEvent.destroy_all }

      context "when successful" do
        it "destroys the lesson" do
          expect do
            admin_request :delete, :destroy, locale, id: lesson.id,
                                                     locale: lesson.locale
          end.to change { Lesson.where(id: lesson.id).count }.by(-1)
        end

        it "redirects to the lessons url" do
          admin_request :delete, :destroy, locale, id: lesson.id, locale: lesson.locale

          expect(response).to redirect_to lessons_url(locale: lesson.locale)
        end
      end

      context "when unsuccessful" do
        it "renders the new template" do
          allow(lesson).to receive(:destroy) { false }
          allow(Lesson).to receive_message_chain("where.find" => lesson)

          admin_request :delete, :destroy, locale, id: lesson.id, locale: locale

          expect(response).to redirect_to lessons_url
        end
      end
    end
  end

  describe "POST slide_order" do
    context "for unauthenticated requests" do
      before { post :slide_order, id: 1 }

      it_behaves_like "a rejected user action"
    end

    context "for authenticated requests by admins or nurses" do
      context "when successful" do
        it "renders the slide order success template" do
          slide = lesson.build_slide(title: "t", body: "b").tap(&:save!)

          admin_request :post, :slide_order, locale, id: lesson.id, slide: [slide.id],
                                                     format: :js, locale: lesson.locale

          expect(response).to render_template :slide_order_success
        end
      end

      context "when unsuccessful" do
        it "renders the slide order failure template" do
          admin_request :post, :slide_order, locale, id: lesson.id, slide: [-1],
                                                     format: :js, locale: lesson.locale

          expect(response).to render_template :slide_order_failure
        end
      end
    end
  end
end
