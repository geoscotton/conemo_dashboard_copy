# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Study identifiers API", type: :request do
  it "responds with the client's associated study identifier" do
    participant = Participant.create!(
      study_identifier: "02468",
      first_name: "f", last_name: "l", family_health_unit_name: "f",
      address: "a", gender: "male", locale: "pt-BR"
    )
    TokenAuth::AuthenticationToken.create!(
      client_uuid: "client1",
      entity_id: participant.id,
      value: SecureRandom.uuid
    )

    headers = { "ACCEPT" => "application/json" }
    get "/api/study_identifier?client_uuid=client1", headers

    expect(response.body).to include "02468"
  end
end
