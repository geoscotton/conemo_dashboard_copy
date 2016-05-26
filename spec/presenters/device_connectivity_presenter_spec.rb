# frozen_string_literal: true
require "rails_helper"

RSpec.describe DeviceConnectivityPresenter do
  describe "#lost_by?" do
    context "when the last connection was long before the date" do
      it "returns true" do
        device = instance_double(Device, last_seen_at: 2.days.ago)
        allow(Device).to receive(:find_by) { device }
        connectivity = DeviceConnectivityPresenter.new("participant")

        expect(connectivity.lost_by?(Time.zone.today)).to be true
      end
    end

    context "when the last connection was very recent" do
      it "returns false" do
        device = instance_double(Device, last_seen_at: 1.hour.ago)
        allow(Device).to receive(:find_by) { device }
        connectivity = DeviceConnectivityPresenter.new("participant")

        expect(connectivity.lost_by?(Time.zone.today)).to be false
      end
    end
  end
end
