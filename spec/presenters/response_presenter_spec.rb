# frozen_string_literal: true
require "spec_helper"

describe ResponsePresenter do
  include ActionView::TestCase::Behavior

  it "says when none given" do
    presenter = ResponsePresenter.new(Response.new, view)
    expect(presenter.formatted_answers).to include("None given")
  end

  it "presents a single key/value pair" do
    response = Response.new(answer: '{"key": "single_value"}')
    presenter = ResponsePresenter.new(response, view)
    expect(presenter.formatted_answers).to include("Key", "single_value")
  end

  it "presents a single key with multiple values" do
    response = Response.new(answer: '{"key": "[value_1, value_2, value_3]"}')
    presenter = ResponsePresenter.new(response, view)
    expect(presenter.formatted_answers).to include("value_1", "value_2", "value_3")
  end

  it "presents multiple key/value pairs" do
    response = Response.new(answer: '{"key_1": "value_1", "key_2": "value_2"}')
    presenter = ResponsePresenter.new(response, view)
    expect(presenter.formatted_answers).to include("Key 1", "Key 2", "value_1", "value_2")
  end
end
