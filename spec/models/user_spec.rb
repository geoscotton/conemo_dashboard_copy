# frozen_string_literal: true
require "rails_helper"

RSpec.describe User do
  fixtures :all

  describe "password setting" do
    context "when no password exists" do
      it "sets one" do
        expect(User.new.tap(&:valid?).password).not_to be_nil
      end
    end

    context "when a password exists" do
      it "doesn't set one" do
        expect(User.first.tap(&:valid?).password).to be_nil
      end
    end

    context "when a password is provided" do
      it "gets set" do
        expect(User.new(password: "blah").tap(&:valid?).password).not_to be_nil
      end
    end
  end
end
