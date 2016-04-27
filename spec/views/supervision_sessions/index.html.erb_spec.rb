# frozen_string_literal: true
require "rails_helper"

RSpec.describe "supervision_sessions/index", type: :view do
  let(:template) { "supervision_sessions/index" }
  let(:nurse) do
    instance_double(Nurse,
                    supervisor_notes: [],
                    recent_supervision_sessions: [])
  end
  let(:time1) { Time.zone.now }
  let(:time2) { Time.zone.now - 5.minutes }

  def stub_nurse
    assign(:nurse, nurse)
  end

  describe "supervisor notes" do
    let(:note1) do
      instance_double(SupervisorNote, note: "Note 1", created_at: time1)
    end
    let(:note2) do
      instance_double(SupervisorNote, note: "Note 2", created_at: time2)
    end

    it "lists note content" do
      stub_nurse
      allow(nurse).to receive(:supervisor_notes)
        .and_return([note1, note2])

      render template: template

      expect(rendered).to match(/Note 1/)
      expect(rendered).to match(/Note 2/)
    end
  end

  describe "supervision sessions" do
    let(:session) do
      instance_double(SupervisionSession,
                      session_at: time1,
                      session_length: 57,
                      meeting_kind: "Group",
                      contact_kind: "In person",
                      topics: ["topic 1", "topic 2"])
    end

    it "lists session details" do
      stub_nurse
      allow(nurse).to receive(:recent_supervision_sessions) { [session] }

      render template: template

      expect(rendered).to match I18n.l(time1, format: :long)
      expect(rendered).to match(/57/)
      expect(rendered).to match(/Group/)
      expect(rendered).to match(/In person/)
      expect(rendered).to match(/topic 1, topic 2/)
    end
  end
end
