# frozen_string_literal: true
require "rails_helper"

RSpec.describe SupervisionSessionPresenter do
  describe "#css_class" do
    let(:nurse) { instance_double(Nurse, timezone: "Lima") }
    let(:session) do
      instance_double(SupervisionSession, nurse: nurse)
    end

    context "when the session was recent" do
      it "returns the 'current' class" do
        allow(session).to receive(:session_at)
          .and_return(2.business_days.before(Time.zone.now))
        presenter = SupervisionSessionPresenter.new(session)

        expect(presenter.css_class)
          .to eq SupervisionSessionPresenter::CSS_CLASSES.current
      end
    end

    context "when the session was tardy" do
      it "returns the 'tardy' class" do
        allow(session).to receive(:session_at)
          .and_return(10.business_days.before(Time.zone.now))
        presenter = SupervisionSessionPresenter.new(session)

        expect(presenter.css_class)
          .to eq SupervisionSessionPresenter::CSS_CLASSES.tardy
      end
    end

    context "when the session was late" do
      it "returns the 'late' class" do
        allow(session).to receive(:session_at)
          .and_return(14.business_days.before(Time.zone.now))
        presenter = SupervisionSessionPresenter.new(session)

        expect(presenter.css_class)
          .to eq SupervisionSessionPresenter::CSS_CLASSES.late
      end
    end
  end
end
