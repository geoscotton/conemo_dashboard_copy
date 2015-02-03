# Parses and renders JSON responses stored in responses table
class ResponsePresenter
  def initialize(response, template)
    @response = response
    @template = template
    @answers = @response.answer ? @response.parse_responses : nil
  end

  def formatted_answers
    handle_none @answers do
      content = ''
      @answers.each do |key, value|
        content += h.content_tag :p, ("#{format_key(key)}"<<': '<<formatted_values(value))
      end
      content.html_safe
    end
  end

  def format_key(key)
    key.gsub(/[_]/, ' ').capitalize
  end
 
  def formatted_values(value)
    if value.kind_of?(Array)
      value_string = value.join(", ")
    else
      value_string = value
    end
    value_string
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
