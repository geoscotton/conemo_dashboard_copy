# frozen_string_literal: true
require "rails_helper"
require "rake"

RSpec.describe "sms:message" do
  fixtures :all

  let(:task_path) { "lib/tasks/sms" }

  subject { Rake::Task["sms:message"] }

  def loaded_files_excluding_current_rake_file
    $LOADED_FEATURES.reject do |file|
      file == Rails.root.join("#{task_path}.rake").to_s
    end
  end

  def prepare_task
    Rake.application.rake_require(task_path,
                                  [Rails.root.to_s],
                                  loaded_files_excluding_current_rake_file)
    Rake::Task.define_task(:environment)
    allow($stdout).to receive(:write) # Hiding puts output
  end

  describe "SMS messages" do
    it "get sent" do
      prepare_task
      subject.reenable

      subject.invoke
    end
  end
end
