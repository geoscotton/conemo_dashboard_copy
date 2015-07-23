require "spec_helper"

RSpec.describe "active/participants/_dialogues_table", type: :view do
  let(:content_access_event) do
    instance_double("ContentAccessEvent", answer: "because lol")
  end
  let(:content_access_events) do
    double("Access events", find_by: content_access_event)
  end
  let(:participant) do
    instance_double("Participant", start_date: nil, id: 12345)
  end
  let(:dialogue) do
    instance_double("Dialogue",
                    day_in_treatment: 2,
                    message: "Lorem ipsum",
                    content_access_events: content_access_events)
  end
  let(:dialogues) { [dialogue] }

  context "when the participant has no start date" do
    it "does not render the dialogue release date" do
      render partial: "active/participants/dialogues_table.html.erb",
             locals: { dialogues: dialogues, participant: participant }

      expect(rendered).to have_selector(".release-day", text: "(2)")
    end
  end

  context "when the participant has a start date" do
    it "renders the dialogue release date" do
      allow(participant).to receive(:start_date) { Date.parse("2000-07-13") }

      render partial: "active/participants/dialogues_table.html.erb",
             locals: { dialogues: dialogues, participant: participant }

      date_str = I18n.l(Date.parse("2000-07-14"), format: :long)
      expect(rendered).to have_selector(".release-day", text: "(2) #{ date_str }")
    end
  end

  it "renders the dialogue message" do
    render partial: "active/participants/dialogues_table.html.erb",
           locals: { dialogues: dialogues, participant: participant }

    expect(rendered).to have_selector(".dialogue-message", text: "Lorem ipsum")
  end

  context "when there is a content access event" do
    it "renders the participant answer" do
      render partial: "active/participants/dialogues_table.html.erb",
             locals: { dialogues: dialogues, participant: participant }

      expect(rendered).to have_selector(".patient-response", text: "because lol")
    end
  end

  context "when there are no content access events" do
    it "does not render a participant answer" do
      allow(content_access_events).to receive(:find_by) { [] }
      render partial: "active/participants/dialogues_table.html.erb",
             locals: { dialogues: dialogues, participant: participant }

      expect(rendered).to have_selector(".patient-response", text: "")
    end
  end
end
