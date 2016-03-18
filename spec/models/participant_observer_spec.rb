# frozen_string_literal: true
require "rails_helper"

RSpec.describe ParticipantObserver do
  fixtures :participants, :users

  let(:participant) { Participant.where.not(nurse: nil).first }
  let(:observer) { ParticipantObserver.instance }

  it "creates a Confirmation Call Task the first time a Nurse is assigned" do
    NurseTask.destroy_all

    expect do
      observer.after_save(participant)
      observer.after_save(participant)
    end.to change {
      Tasks::ConfirmationCall.for_participant(participant).count
    }.by(1)
  end

  describe "pushable resource creation" do
    %w(
      Device
      ExceptionReport
      HelpMessage
      Login
      SessionEvent
    ).each do |resource|
      it "creates a #{resource} resource" do
        expect { observer.after_save(participant) }.to change {
          TokenAuth::SynchronizableResource.where(class_name: resource,
                                                  is_pushable: true,
                                                  is_pullable: false).count
        }.by(1)
      end
    end
  end

  describe "synchronizable resource creation" do
    %w(
      ContentAccessEvent
      ParticipantStartDate
      PlannedActivity
    ).each do |resource|
      it "creates a #{resource} resource" do
        expect { observer.after_save(participant) }.to change {
          TokenAuth::SynchronizableResource.where(class_name: resource,
                                                  is_pullable: true,
                                                  is_pushable: true).count
        }.by(1)
      end
    end
  end

  describe "configuration token creation" do
    it "occurs on participant creation" do
      expect { observer.after_create(participant) }.to change {
        TokenAuth::ConfigurationToken.count
      }.by(1)
    end
  end
end
