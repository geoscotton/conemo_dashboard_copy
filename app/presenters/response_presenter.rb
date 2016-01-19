# Parses and renders JSON responses stored in responses table
class ResponsePresenter
  def initialize(response, template)
    @response = response
    @template = template
    @answers = @response.answer ? @response.parse_responses : nil
  end

  def formatted_answers
    handle_none @answers do
      @answers.map do |key, value|
        h.content_tag :p, (format_key(key) << ": " << formatted_values(value))
      end.join("").html_safe
    end
  end

  def format_key(key)
    sanitized_key = ActionController::Base.helpers.sanitize(key)
    sanitized_key.gsub(/[_]/, " ").capitalize
  end
 
  def formatted_values(value)
    ActionController::Base.helpers.sanitize(value.kind_of?(Array) ? value.join(", ") : value)
  end
  
  private
  def h
    @template
  end
  
  def handle_none(value)
    if value.present?
      yield
    else
      h.content_tag :span, "None given", class: "none"
    end
  end
end
