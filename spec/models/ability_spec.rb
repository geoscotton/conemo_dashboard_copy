# frozen_string_literal: true
require "rails_helper"

RSpec.describe Ability do
  fixtures :all

  let(:en_participant) { participants(:participant1) }
  let(:pt_participant) { participants(:portuguese_active_participant) }
  let(:en_nurse) { users(:nurse1) }

  describe "Superuser permissions" do
    let(:superuser_role) { Ability.new(Superuser.first) }

    it "can manage all models" do
      expect(superuser_role.can?(:manage, :all)).to eq true
    end
  end

  describe "Admin permissions" do
    let(:en_admin_role) { Ability.new(users(:admin1)) }
    let(:es_nurse) { users(:peruvian_nurse) }
    let(:en_lesson) { lessons(:day1) }
    let(:pt_lesson) { lessons(:day1_pt) }

    it "can manage Nurses of the same locale" do
      en_nurses = User.where(role: User::ROLES[:nurse], locale: LOCALES[:en])
      expect(en_admin_role.can?(:manage, en_nurses)).to eq true
    end

    it "cannot manage a Nurse of a different locale" do
      expect(en_admin_role.can?(:manage, es_nurse)).to eq false
    end

    it "can manage Participants of the same locale" do
      en_participants = Participant.where(locale: LOCALES[:en])
      expect(en_admin_role.can?(:manage, en_participants)).to eq true
    end

    it "cannot manage a Participant of a different locale" do
      expect(en_admin_role.can?(:manage, pt_participant)).to eq false
    end

    it "can manage a Lesson and Slides of the same locale" do
      expect(en_admin_role.can?(:manage, en_lesson)).to eq true
      expect(en_admin_role.can?(:manage, en_lesson.slides)).to eq true
    end

    it "can manage Lessons of the same locale" do
      en_lessons = Lesson.where(locale: LOCALES[:en])
      expect(en_admin_role.can?(:manage, en_lessons)).to eq true
    end

    it "cannot manage a Lesson of a different locale" do
      expect(en_admin_role.can?(:manage, pt_lesson)).to eq false
    end

    it "can manage Devices" do
      expect(en_admin_role.can?(:manage, Device.all)).to eq true
    end
  end

  describe "Nurse Supervisor permissions" do
    let(:en_nurse_supervisor_role) do
      Ability.new(users(:en_nurse_supervisor_1))
    end

    it "can read Participants of the same locale" do
      en_participants = Participant.where(locale: LOCALES[:en])
      expect(en_nurse_supervisor_role.can?(:read, en_participants)).to eq true
    end

    it "can update Participants of the same locale" do
      en_participants = Participant.where(locale: LOCALES[:en])
      expect(en_nurse_supervisor_role.can?(:update, en_participants)).to eq true
    end

    it "cannot read a Participant of a different locale" do
      expect(en_nurse_supervisor_role.can?(:read, pt_participant)).to eq false
    end

    it "can create SupervisionContact for assigned Nurses" do
      contact = SupervisionContact.new(nurse: en_nurse)

      expect(en_nurse_supervisor_role.can?(:create, contact)).to eq true
    end

    it "can create SupervisionSession for assigned Nurses" do
      session = SupervisionSession.new(nurse: en_nurse)

      expect(en_nurse_supervisor_role.can?(:create, session)).to eq true
    end
  end

  describe "Nurse permissions" do
    let(:en_nurse_role) { Ability.new(en_nurse) }

    it "can read active assigned Participants" do
      en_nurse_participants = Participant.active.where(nurse: en_nurse)
      expect(en_nurse_participants.count > 0).to eq true

      expect(en_nurse_role.can?(:read, en_nurse_participants)).to eq true
    end

    it "cannot read pending assigned Participants" do
      en_nurse_participants = Participant.pending.where(nurse: en_nurse)
      expect(en_nurse_participants.count > 0).to eq true

      expect(en_nurse_role.can?(:read, en_nurse_participants)).to eq false
    end

    it "cannot read active unassigned Participants" do
      en_nurse_participants = Participant.active.where.not(nurse: en_nurse)
      expect(en_nurse_participants.count > 0).to eq true

      expect(en_nurse_role.can?(:read, en_nurse_participants)).to eq false
    end

    it "can update active assigned Participants" do
      en_nurse_participants = Participant.active.where(nurse: en_nurse)
      expect(en_nurse_participants.count > 0).to eq true

      expect(en_nurse_role.can?(:update, en_nurse_participants)).to eq true
    end

    it "can create CallToScheduleFinalAppointments for assigned Participants" do
      en_nurse_participant = Participant.active.find_by(nurse: en_nurse)

      call =
        CallToScheduleFinalAppointment.new(participant: en_nurse_participant)
      expect(en_nurse_role.can?(:create, call)).to eq true
    end

    it "can update CallToScheduleFinalAppointments for assigned Participants" do
      en_nurse_participant = Participant.active.find_by(nurse: en_nurse)

      call =
        CallToScheduleFinalAppointment.new(participant: en_nurse_participant)
      expect(en_nurse_role.can?(:update, call)).to eq true
    end

    it "can update NurseTasks for assigned Participants" do
      en_nurse_tasks = NurseTask.where(participant: en_nurse.participants)
      expect(en_nurse_tasks.count > 0).to eq true

      expect(en_nurse_role.can?(:update, en_nurse_tasks)).to eq true
    end

    it "can create AdditionalContacts for assigned Participants" do
      en_nurse_participant = Participant.active.find_by(nurse: en_nurse)

      contact = AdditionalContact.new(participant: en_nurse_participant)
      expect(en_nurse_role.can?(:create, contact)).to eq true
    end

    it "can create HelpRequestCalls for assigned Participants" do
      en_nurse_participant = Participant.active.find_by(nurse: en_nurse)

      contact = HelpRequestCall.new(participant: en_nurse_participant)
      expect(en_nurse_role.can?(:create, contact)).to eq true
    end

    it "can create LackOfConnectivityCalls for assigned Participants" do
      en_nurse_participant = Participant.active.find_by(nurse: en_nurse)

      contact = LackOfConnectivityCall.new(participant: en_nurse_participant)
      expect(en_nurse_role.can?(:create, contact)).to eq true
    end

    it "can create NonAdherenceCalls for assigned Participants" do
      en_nurse_participant = Participant.active.find_by(nurse: en_nurse)

      contact = NonAdherenceCall.new(participant: en_nurse_participant)
      expect(en_nurse_role.can?(:create, contact)).to eq true
    end

    it "can create ScheduledTaskCancellations for assigned Participants" do
      en_nurse_participant = Participant.active.find_by(nurse: en_nurse)

      contact = NurseTask.new(participant: en_nurse_participant)
      cancellation = ScheduledTaskCancellation.new(nurse_task: contact)
      expect(en_nurse_role.can?(:create, cancellation)).to eq true
    end
  end
end
