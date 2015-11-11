module ControllerSpecHelpers
  def sign_in_admin
    sign_in_user instance_double(
      User,
      nurse?: false,
      locale: %w( en pt-BR es-PE ).sample,
      timezone: "America/Chicago"
    )
  end

  def sign_in_user(user = double("user"))
    sign_in_resource(user, "user")
  end

  def sign_in_admin
    sign_in_user instance_double(
      User,
      nurse?: false,
      locale: %w( en pt-BR es-PE ).sample,
      timezone: "America/Chicago"
    )
  end

  private

  def sign_in_resource(resource, name)
    if resource.nil?
      expect(request.env["warden"]).to receive(:authenticate!)
        .and_throw(:warden, scope: :"#{ name }")
      controller.stub :"current_#{ name }" => nil
    else
      expect(request.env["warden"]).to receive(:authenticate!) { resource }
      allow(controller).to receive("current_#{ name }") { resource }
    end
  end
end

RSpec.configure do |config|
  config.include Devise::TestHelpers, type: :controller
  config.include ControllerSpecHelpers, type: :controller
end

# Shared examples

shared_examples "a rejected user action" do
  it "should redirect to the user login" do
    expect(response).to redirect_to new_user_session_path
  end
end
