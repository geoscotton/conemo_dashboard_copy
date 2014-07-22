require "spec_helper"

describe "appointment scheduler" do
  fixtures(
    :users, :participants, :first_contacts, :first_appointments
  )

  before(:each) do
    sign_in_user users(:admin1)
  end

  let(:participant) { participants(:active_participant) }

  describe "display"
end