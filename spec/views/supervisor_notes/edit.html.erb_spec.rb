# frozen_string_literal: false
require "rails_helper"

RSpec.describe "supervisor_notes/edit", type: :view do
  fixtures :all

  before(:each) do
    @nurse = assign(:nurse, Nurse.first)
    @supervisor_note = assign(:supervisor_note,
                              SupervisorNote.create!(
                                note: "MyText",
                                nurse: @nurse
                              ))
  end

  it "renders the edit supervisor_note form" do
    render

    assert_select(
      "form[action=?][method=?]",
      nurse_supervisor_note_path(@nurse, @supervisor_note),
      "post"
    ) do
      assert_select "textarea#supervisor_note_note[name=?]",
                    "supervisor_note[note]"
    end
  end
end
