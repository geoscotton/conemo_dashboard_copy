# frozen_string_literal: true
require "rails_helper"

RSpec.describe SecondContact, type: :model do
  describe "difficulties sanitization" do
    context "when a single empty selection is provided" do
      it "stores a nil value" do
        contact = SecondContact.new(difficulties: [""]).tap(&:valid?)

        expect(contact.difficulties).to be_nil
      end
    end

    context "when a populated selection is provided" do
      it "removes blanks" do
        contact = SecondContact.new(difficulties: ["", "x", "y"]).tap(&:valid?)

        expect(contact.difficulties).to eq %w( x y )
      end
    end
  end
end
