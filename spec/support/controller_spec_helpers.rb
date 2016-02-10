module ControllerSpecHelpers
  def sign_in_admin(locale)
    @signed_in_user ||= sign_in_user(instance_double(
      User,
      nurse?: false,
      admin?: true,
      locale: locale,
      timezone: "America/Chicago"
    ))
  end

  def sign_in_nurse(locale)
    @signed_in_user ||= sign_in_user(instance_double(
      User,
      nurse?: true,
      admin?: false,
      locale: locale,
      timezone: "America/Chicago"
    ))
  end

  def admin_request(http_method, action, locale, params = {})
    sign_in_admin locale
    send http_method, action, params
  end

  def nurse_request(http_method, action, locale, params = {})
    sign_in_nurse locale
    send http_method, action, params
  end

  def sign_in_user(user = double("user"))
    sign_in_resource(user, "user")
  end

  private

  def sign_in_resource(resource, name)
    if resource.nil?
      expect(request.env["warden"]).to receive(:authenticate!)
        .and_throw(:warden, scope: :"#{name}")
      controller.stub :"current_#{name}" => nil
    else
      expect(request.env["warden"]).to receive(:authenticate!).at_most(5).times
        .and_return(resource)
      allow(controller).to receive("current_#{name}") { resource }
    end

    resource
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
