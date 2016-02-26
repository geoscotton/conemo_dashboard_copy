# frozen_string_literal: true
json._class "Slide"
json.position slide.position
json.title slide.title
json.content render_html_body(slide)
