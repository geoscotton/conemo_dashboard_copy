require "spec_helper"

RSpec.describe "active/participants/_dialogues_table", type: :view do
  let(:participant) do
    instance_double("Participant", start_date: nil, id: 12345)
  end
  let(:dialogue) do
    instance_double("Dialogue",
                    day_in_treatment: 2,
                    message: "Lorem ipsum")
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
end
