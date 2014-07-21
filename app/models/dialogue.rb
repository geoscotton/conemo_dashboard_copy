#Lesson sub-type used for providing purple robot dialogue content
class Dialogue < ActiveRecord::Base
  belongs_to :lesson
end
