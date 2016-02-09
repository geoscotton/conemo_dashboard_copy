require "spec_helper"

RSpec.describe ContentAccessEvent, type: :model do
  fixtures :all

  let(:participant) { participants(:participant1) }

  describe "#response_attributes=" do
    context "when a JSON-formatted string is provided" do
      it "creates an associated Response" do
        expect do
          ContentAccessEvent.create!(
            participant: participant,
            accessed_at: Time.zone.now,
            lesson: Lesson.first,
            day_in_treatment_accessed: 1,
            response_attributes: {
              "answer" => { "foo" => "bar" }
            }.to_json
          )
        end.to change {
          Response.where(answer: { "foo" => "bar" }.to_json).count
        }.by(1)
      end
    end
  end
end
