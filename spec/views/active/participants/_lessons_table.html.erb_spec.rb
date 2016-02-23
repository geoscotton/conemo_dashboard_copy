require "spec_helper"

RSpec.describe "active/participants/_lessons_table", type: :view do
  let(:content_access_events) { double("Access events", where: []) }
  let(:session_event) { double("SessionEvent") }
  let(:session_events) { double("Session events") }
  let(:participant) do
    double("Participant",
           lesson_status: nil,
           start_date: nil,
           access_response: nil,
           id: 12345)
  end
  let(:lesson) do
    double("Lesson",
           day_in_treatment: 2,
           title: "Lorem ipsum",
           content_access_events: content_access_events,
           session_events: session_events)
  end
  let(:lessons) { [lesson] }

  def arrange_stubs
    allow(session_events).to receive_message_chain("accesses.where")
      .and_return([session_event])
  end

  it "renders the lesson release day in treatment" do
    arrange_stubs

    render partial: "active/participants/lessons_table.html.erb",
           locals: { lessons: lessons, participant: participant }

    expect(rendered)
      .to have_selector(".release-day", text: 2)
  end

  context "when the participant has no start date" do
    it "does not render the lesson release date" do
      arrange_stubs

      render partial: "active/participants/lessons_table.html.erb",
             locals: { lessons: lessons, participant: participant }

      expect(rendered)
        .to have_selector(".release-date", text: "")
    end
  end

  context "when the participant has a start date" do
    it "renders the lesson release date" do
      arrange_stubs
      allow(participant).to receive(:start_date) { Date.parse("2000-07-13") }

      render partial: "active/participants/lessons_table.html.erb",
             locals: { lessons: lessons, participant: participant }

      date_str = I18n.l(Date.parse("2000-07-14"), format: :long)
      expect(rendered)
        .to have_selector(".release-date", text: date_str)
    end
  end
end
