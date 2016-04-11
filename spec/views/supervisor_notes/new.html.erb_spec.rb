# frozen_string_literal: false
require "rails_helper"

RSpec.describe "supervisor_notes/new", type: :view do
  fixtures :all

  before(:each) do
    @participant = assign(:participant, Participant.first)
    @supervisor_note = assign(:supervisor_note,
                              SupervisorNote.new(
                                note: "MyText",
                                participant: Participant.first
                              ))
  end

  it "renders new supervisor_note form" do
    render

    assert_select(
      "form[action=?][method=?]",
      participant_supervisor_notes_path(@participant),
      "post"
    ) do
      assert_select "textarea#supervisor_note_note[name=?]",
                    "supervisor_note[note]"
    end
  end
end
