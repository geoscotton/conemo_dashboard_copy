require "spec_helper"

RSpec.describe "active/participants/_lessons_table", type: :view do
  let(:content_access_events) { double("Access events", where: []) }
  let(:participant) do
    instance_double("Participant",
                    lesson_status: nil,
                    start_date: nil,
                    access_response: nil,
                    id: 12345)
  end
  let(:lesson) do
    instance_double("Lesson",
                    day_in_treatment: 2,
                    title: "Lorem ipsum",
                    content_access_events: content_access_events)
  end
  let(:lessons) { [lesson] }

  it "renders the lesson release day in treatment" do
    render partial: "active/participants/lessons_table.html.erb",
           locals: { lessons: lessons, participant: participant }

    expect(rendered)
      .to have_selector(".release-day", text: 2)
  end

  context "when the participant has no start date" do
    it "does not render the lesson release date" do
      render partial: "active/participants/lessons_table.html.erb",
             locals: { lessons: lessons, participant: participant }

      expect(rendered)
        .to have_selector(".release-date", text: "")
    end
  end

  context "when the participant has a start date" do
    it "renders the lesson release date" do
      allow(participant).to receive(:start_date) { Date.parse("2000-07-13") }

      render partial: "active/participants/lessons_table.html.erb",
             locals: { lessons: lessons, participant: participant }

      date_str = I18n.l(Date.parse("2000-07-14"), format: :long)
      expect(rendered)
        .to have_selector(".release-date", text: date_str)
    end
  end
end
