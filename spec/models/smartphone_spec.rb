# frozen_string_literal: true
RSpec.describe Smartphone, type: :model do
  describe "sanitization" do
    it "scrubs non-alphanumerics" do
      smartphone = Smartphone.new(number: "1k2l3JKl456jih78-9=0")

      expect(smartphone.tap(&:valid?).number).to eq "1k2l3JKl456jih7890"

      %w(
        \ \ \ 1234567890
        1#!@#$!@#$234567\(\)*\(*&890
      ).each do |input|
        smartphone = Smartphone.new(number: input)

        expect(smartphone.tap(&:valid?).number).to eq "1234567890"
      end
    end
  end
end
