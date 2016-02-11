require "spec_helper"

RSpec.describe Ability do
  fixtures :all

  let(:en_participant) { participants(:participant1) }
  let(:pt_participant) { participants(:portuguese_active_participant) }

  describe "Admin permissions" do
    let(:en_admin_role) { Ability.new(users(:admin1)) }
    let(:en_nurse) { users(:nurse1) }
    let(:es_nurse) { users(:peruvian_nurse) }
    let(:en_lesson) { lessons(:day1) }
    let(:pt_lesson) { lessons(:day1_pt) }

    it "can manage a Nurse of the same locale" do
      expect(en_admin_role.can?(:manage, en_nurse)).to eq true
    end

    it "can manage Nurses of the same locale" do
      en_nurses = User.where(role: User::ROLES[:nurse], locale: LOCALES[:en])
      expect(en_admin_role.can?(:manage, en_nurses)).to eq true
    end

    it "cannot manage a Nurse of a different locale" do
      expect(en_admin_role.can?(:manage, es_nurse)).to eq false
    end

    it "can manage a Participant of the same locale" do
      expect(en_admin_role.can?(:manage, en_participant)).to eq true
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
  end

  describe "Nurse permissions" do
    let(:en_nurse_role) { Ability.new(users(:nurse1)) }

    it "can read Participants of the same locale" do
      en_participants = Participant.where(locale: LOCALES[:en])
      expect(en_nurse_role.can?(:read, en_participants)).to eq true
    end

    it "can update Participants of the same locale" do
      en_participants = Participant.where(locale: LOCALES[:en])
      expect(en_nurse_role.can?(:update, en_participants)).to eq true
    end

    it "cannot read a Participant of a different locale" do
      expect(en_nurse_role.can?(:read, pt_participant)).to eq false
    end
  end
end
