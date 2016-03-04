# frozen_string_literal: true
RSpec.describe Smartphone, type: :model do
  describe "sanitization" do
    it "scrubs non-digits" do
      %w(
        1k2l3jkl456jih78-9=0
        \ \ \ 1234567890
        1#!@#$!@#$234567\(\)*\(*&890
      ).each do |input|
        smartphone = Smartphone.new(number: input)

        expect(smartphone.tap(&:valid?).number).to eq "1234567890"
      end
    end
  end
end
