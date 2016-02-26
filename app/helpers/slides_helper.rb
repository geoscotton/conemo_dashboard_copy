# frozen_string_literal: true
# Helpers for Slide views.
module SlidesHelper
  def render_html_body(slide)
    slide.body.html_safe
  end
end
