# frozen_string_literal: true
# Top level helper.
module ApplicationHelper
  def present(object)
    presenter = ResponsePresenter.new(object, self)
    yield presenter if block_given?
    presenter
  end
end
