# frozen_string_literal: true
# Override BitCore Slideshow for compatibility.
module BitCoreDecorators
  BitCore::Slideshow.class_eval do
    def arm_id
      1
    end
  end
end
