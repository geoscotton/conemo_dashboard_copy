# frozen_string_literal: true
require "rails_helper"

RSpec.describe DeviceConnectivityPresenter do
  describe "#lack_of_on_release_day?" do
    let(:participant) { instance_double(Participant, start_date: Date.yesterday) }
    let(:connectivity) { DeviceConnectivityPresenter.new(participant) }
    let(:release_day) { 1 }
    let(:release_timestamp) { connectivity.release_timestamp(release_day) }

    def device_seen(time_seen)
      device = instance_double(Device, last_seen_at: time_seen)
      allow(Device).to receive(:find_by) { device }
    end

    context "when the device record is missing" do
      it "returns false" do
        allow(Device).to receive(:find_by) { nil }

        expect(connectivity.lack_of_on_release_day?(1, 3)).to be false
      end
    end

    context "when there has been no lack of connectivity" do
      it "returns false" do
        device_seen(2.minutes.ago)

        expect(connectivity.lack_of_on_release_day?(1, nil)).to be false
      end
    end

    context "when the lack of connectivity has been long" do
      context "and at least 12 hours of it was before the release" do
        it "returns true" do
          device_seen(release_timestamp - 13.hours)

          expect(connectivity.lack_of_on_release_day?(release_day, nil)).to be true
        end
      end

      context "and less than 12 hours of it was before the release" do
        context "and less than 12 hours of it was after the release" do
          it "returns false" do
            device_seen(release_timestamp - 11.hours)

            Timecop.travel(release_timestamp + 11.hours) do
              expect(connectivity.lack_of_on_release_day?(release_day, nil)).to be false
            end
          end
        end

        context "and more than 12 hours of it was after the release" do
          it "returns true" do
            device_seen(release_timestamp - 11.hours)

            Timecop.travel(release_timestamp + 13.hours) do
              expect(connectivity.lack_of_on_release_day?(release_day, nil)).to be true
            end
          end
        end
      end
    end

    context "when the lack of connectivity started after lesson release" do
      context "and less than 12 hours has passed" do
        it "returns false" do
          device_seen(release_timestamp + 4.hours)

          Timecop.travel(release_timestamp + 14.hours) do
            expect(connectivity.lack_of_on_release_day?(release_day, nil)).to be false
          end
        end
      end

      context "and more than 12 hours has passed" do
        it "returns true" do
          device_seen(release_timestamp + 1.hour)

          Timecop.travel(release_timestamp + 15.hours) do
            expect(connectivity.lack_of_on_release_day?(release_day, nil)).to be true
          end
        end
      end

      it "returns false for the previous lesson" do
        device_seen(release_timestamp + 25.hours)

        Timecop.travel(release_timestamp + 40.hours) do
          expect(connectivity.lack_of_on_release_day?(release_day,
                                                      release_day + 1)).to be false
        end
      end
    end
  end
end
