require "spec_helper"

RSpec.describe SlidesController, type: :controller do
  LOCALES = %w( en pt-BR es-PE )

  fixtures :all

  let(:slide) { BitCore::Slide.first }

  let(:lesson) { Lesson.find(slide.bit_core_slideshow_id) }

  let(:valid_slide_params) do
    { title: "t", body: "b", position: 2, bit_core_slideshow: lesson }
  end

  let(:invalid_slide_params) do
    { title: nil, body: nil }
  end

  let(:locale) { LOCALES.sample }

  def authorize!
    allow(controller).to receive(:authorize!)
  end

  describe "GET show" do
    context "for unauthenticated requests" do
      before { get :show, lesson_id: 1, id: 1 }

      it_behaves_like "a rejected user action"
    end

    context "for authenticated requests by admins or nurses" do
      context "when the slide is found" do
        it "sets the slide" do
          authorize!

          admin_request :get, :show, lesson_id: lesson.id, id: slide.id

          expect(assigns(:slide)).to eq slide
        end
      end
    end
  end

  describe "GET new" do
    context "for unauthenticated requests" do
      before { get :new, lesson_id: lesson.id }

      it_behaves_like "a rejected user action"
    end

    context "for authenticated requests by admins or nurses" do
      it "sets the slide" do
        authorize!

        admin_request :get, :new, lesson_id: lesson.id

        expect(assigns(:slide)).to be_instance_of BitCore::Slide
        expect(assigns(:slide).slideshow.id).to eq lesson.id
      end
    end
  end

  describe "GET edit" do
    context "for unauthenticated requests" do
      before { get :edit, lesson_id: lesson.id, id: 1 }

      it_behaves_like "a rejected user action"
    end

    context "for authenticated requests by admins or nurses" do
      it "sets the slide" do
        authorize!

        admin_request :get, :edit, lesson_id: lesson.id, id: slide.id

        expect(assigns(:slide)).to eq slide
      end
    end
  end

  describe "POST create" do
    context "for unauthenticated requests" do
      before { post :create, lesson_id: lesson.id }

      it_behaves_like "a rejected user action"
    end

    context "for authenticated requests by admins or nurses" do
      context "when successful" do
        it "creates a slide" do
          authorize!

          expect do
            admin_request :post, :create, lesson_id: lesson.id,
                          slide: valid_slide_params
          end.to change { BitCore::Slide.count }.by(1)
        end

        it "redirects to the lesson url" do
          authorize!

          admin_request :post, :create, lesson_id: lesson.id,
                        slide: valid_slide_params

          expect(response).to redirect_to lesson_url(lesson)
        end
      end

      context "when unsuccessful" do
        it "renders the new template" do
          authorize!

          admin_request :post, :create, lesson_id: lesson.id,
                        slide: invalid_slide_params

          expect(response).to render_template :new
        end
      end
    end
  end

  describe "PUT update" do
    context "for unauthenticated requests" do
      before { put :update, lesson_id: lesson.id, id: 1 }

      it_behaves_like "a rejected user action"
    end

    context "for authenticated requests by admins or nurses" do
      context "when successful" do
        it "updates the slide" do
          authorize!

          expect do
            admin_request :put, :update, lesson_id: lesson.id, id: slide.id,
                          slide: valid_slide_params
          end.to change { BitCore::Slide.find(slide.id).updated_at }
        end

        it "redirects to the lesson url" do
          authorize!

          admin_request :put, :update, lesson_id: lesson.id, id: slide.id,
                        slide: valid_slide_params

          expect(response).to redirect_to lesson_url(lesson)
        end
      end

      context "when unsuccessful" do
        it "renders the edit template" do
          authorize!

          admin_request :put, :update, lesson_id: lesson.id, id: slide.id,
                        slide: invalid_slide_params

          expect(response).to render_template :edit
        end
      end
    end
  end

  describe "DELETE destroy" do
    context "for unauthenticated requests" do
      before { delete :destroy, lesson_id: lesson.id, id: 1 }

      it_behaves_like "a rejected user action"
    end

    context "for authenticated requests by admins or nurses" do
      context "when successful" do
        it "destroys the slide" do
          authorize!

          expect do
            admin_request :delete, :destroy, lesson_id: lesson.id, id: slide.id
          end.to change { BitCore::Slide.where(id: slide.id).count }.by(-1)
        end

        it "redirects to the lesson url" do
          authorize!

          admin_request :delete, :destroy, lesson_id: lesson.id, id: slide.id

          expect(response).to redirect_to lesson_url(lesson)
        end
      end

      context "when unsuccessful" do
        it "redirects to the lesson url" do
          allow(lesson).to receive(:destroy_slide).with(slide) { false }
          allow(Lesson).to receive(:find).with(lesson.id.to_s) { lesson }
          allow(slide).to receive_message_chain("errors.full_messages" => [])
          allow(BitCore::Slide).to receive_message_chain("where.find" => slide)
          authorize!

          admin_request :delete, :destroy, lesson_id: lesson.id, id: slide.id

          expect(response).to redirect_to lesson_url(lesson)
        end
      end
    end
  end

  #describe "POST slide_order" do
  #  context "for unauthenticated requests" do
  #    before { post :slide_order, id: 1 }

  #    it_behaves_like "a rejected user action"
  #  end

  #  context "for authenticated requests by admins or nurses" do
  #    context "when successful" do
  #      it "renders the slide order success template" do
  #        authorize!
  #        slide = slide.build_slide(title: "t", body: "b").tap(&:save!)

  #        admin_request :post, :slide_order, id: slide.id, slide: [slide.id],
  #                      format: :js

  #        expect(response).to render_template :slide_order_success
  #      end
  #    end

  #    context "when unsuccessful" do
  #      it "renders the slide order failure template" do
  #        authorize!

  #        admin_request :post, :slide_order, id: slide.id, slide: [-1],
  #                      format: :js

  #        expect(response).to render_template :slide_order_failure
  #      end
  #    end
  #  end
  #end
end
