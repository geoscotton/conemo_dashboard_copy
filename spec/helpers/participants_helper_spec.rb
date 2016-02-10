require "spec_helper"

RSpec.describe ParticipantsHelper, type: :helper do
  fixtures :all

  let(:completed_participant) do
    instance_double(Participant,
                    first_contact: true,
                    first_appointment: true,
                    second_contact: true,
                    third_contact: true,
                    final_appointment: true)
  end

  describe "#first_contact" do
    context "when there is an associated first contact" do
      it "returns a checked circle icon" do
        output = helper.first_contact(completed_participant)

        expect(output).to include "fa-check-circle"
      end
    end

    context "when there is not an associated first contact" do
      it "returns a link to create a first contact" do
        participant = Participant.first
        participant.first_contact.try(:destroy)
        participant.reload
        output = helper.first_contact(participant)

        path = new_participant_first_contact_path(participant)
        expect(output).to include "href=\"#{path}\""
      end
    end
  end

  describe "#first_appointment" do
    context "when there is an associated first appointment" do
      it "returns a checked circle icon" do
        output = helper.first_appointment(completed_participant)

        expect(output).to include "fa-check-circle"
      end
    end

    context "when there is not an associated first appointment" do
      context "and there is an associated first contact" do
        it "returns info about the first appointment" do
          participant = Participant.first
          participant.first_appointment.try(:destroy)
          participant.reload
          output = helper.first_appointment(participant)

          expect(output)
            .to include participant.first_contact.first_appointment_location
        end
      end
    end
  end

  describe "#second_contact" do
    context "when there is an associated second contact" do
      it "returns a checked circle icon" do
        output = helper.second_contact(completed_participant)

        expect(output).to include "fa-check-circle"
      end
    end
  end

  describe "#second_contact_link" do
    context "when there is an associated second contact" do
      it "returns an empty string" do
        expect(helper.second_contact_link(completed_participant)).to eq ""
      end
    end
  end

  describe "#reschedule_second_contact" do
    context "when there is an associated second contact" do
      it "returns an empty string" do
        expect(helper.reschedule_second_contact(completed_participant)).to eq ""
      end
    end
  end

  describe "#third_contact" do
    context "when there is an associated third contact" do
      it "returns a checked circle icon" do
        output = helper.third_contact(completed_participant)

        expect(output).to include "fa-check-circle"
      end
    end

    context "when there is not an associated third contact" do
      context "and there is an associated second contact" do
        it "returns info about the third contact" do
          participant = Participant.third
          participant.third_contact.try(:destroy)
          participant.create_second_contact(
            contact_at: Time.zone.now,
            session_length: 1,
            next_contact: Time.zone.now
          )
          participant.reload
          output = helper.third_contact(participant)

          expect(output)
            .to include I18n.l(participant.second_contact.next_contact,
                               format: :short)
        end
      end
    end
  end

  describe "#third_contact_link" do
    context "when there is an associated third contact" do
      it "returns an empty string" do
        expect(helper.third_contact_link(completed_participant)).to eq ""
      end
    end

    context "when there is not an associated third contact" do
      context "and there is an associated second contact" do
        it "returns a link to create a third contact" do
          participant = Participant.first
          participant.third_contact.try(:destroy)
          participant.create_second_contact(
            contact_at: Time.zone.now,
            session_length: 1,
            next_contact: Time.zone.now
          )
          participant.reload
          output = helper.third_contact_link(participant)

          path = new_participant_third_contact_path(participant)
          expect(output).to include "href=\"#{path}\""
        end
      end
    end
  end

  describe "#reschedule_third_contact" do
    context "when there is an associated third contact" do
      it "returns an empty string" do
        expect(helper.reschedule_third_contact(completed_participant)).to eq ""
      end
    end

    context "when there is not an associated third contact" do
      context "and there is an associated second contact" do
        it "returns a link to create a third contact" do
          participant = Participant.first
          participant.third_contact.try(:destroy)
          participant.create_second_contact(
            contact_at: Time.zone.now,
            session_length: 1,
            next_contact: Time.zone.now
          )
          participant.reload
          output = helper.reschedule_third_contact(participant)

          path = missed_third_contact_path(participant_id: participant.id,
                                           id: participant.second_contact.id)
          expect(output).to include "href=\"#{path}\""
        end
      end
    end
  end

  describe "#final_appointment" do
    context "when there is an associated final appointment" do
      it "returns a checked circle icon" do
        expect(helper.final_appointment(completed_participant))
          .to include "fa-check-circle"
      end
    end

    context "when there is not an associated final appointment" do
      context "and there is an associated third contact" do
        it "returns info about the final appointment" do
          participant = Participant.first
          participant.final_appointment.try(:destroy)
          participant.create_third_contact(
            contact_at: Time.zone.now,
            session_length: 1,
            final_appointment_at: Time.zone.now,
            final_appointment_location: "inside"
          )
          participant.reload
          output = helper.final_appointment(participant)

          expect(output)
            .to include I18n.l(participant.third_contact.final_appointment_at,
                               format: :short)
        end
      end
    end
  end

  describe "#final_appointment_link" do
    context "when there is an associated final appointment" do
      it "returns an empty string" do
        expect(helper.final_appointment_link(completed_participant)).to eq ""
      end
    end

    context "when there is not an associated final appointment" do
      context "and there is an associated third contact" do
        it "returns a link to create a final appointment" do
          participant = Participant.first
          participant.final_appointment.try(:destroy)
          participant.create_third_contact(
            contact_at: Time.zone.now,
            session_length: 1,
            final_appointment_at: Time.zone.now,
            final_appointment_location: "inside"
          )
          participant.reload
          output = helper.final_appointment_link(participant)

          path = new_participant_final_appointment_path(participant)
          expect(output).to include "href=\"#{path}\""
        end
      end
    end
  end

  describe "#reschedule_final_appointment" do
    context "when there is an associated final appointment" do
      it "returns an empty string" do
        expect(helper.reschedule_final_appointment(completed_participant))
          .to eq ""
      end
    end

    context "when there is not an associated final appointment" do
      context "and there is an associated third contact" do
        it "returns a link to reschedule a final appointment" do
          participant = Participant.first
          participant.final_appointment.try(:destroy)
          participant.create_third_contact(
            contact_at: Time.zone.now,
            session_length: 1,
            final_appointment_at: Time.zone.now,
            final_appointment_location: "inside"
          )
          participant.reload
          output = helper.reschedule_final_appointment(participant)

          path = missed_final_appointment_path(participant_id: participant.id,
                                               id: participant.third_contact.id)
          expect(output).to include "href=\"#{path}\""
        end
      end
    end
  end

  describe "#render_status_link" do
    context "when there are unread help messages" do
      it "returns a blinking link" do
        participant = Participant.first
        participant.help_messages.create!(
          read: false, sent_at: Time.zone.now, message: "m"
        )
        participant.reload

        output = helper.render_status_link(participant)

        expect(output).to include "blink-me"
      end
    end

    context "when there are no unread help messages" do
      it "returns a non-blinking link" do
        participant = Participant.first
        participant.help_messages.destroy_all
        participant.reload

        output = helper.render_status_link(participant)

        expect(output).not_to include "blink-me"
      end
    end
  end

  describe "#study_status" do
    context "when current study status is 'warning'" do
      it "returns 'yellow'" do
        participant = instance_double(Participant, current_study_status: "warning")

        expect(helper.study_status(participant)).to eq "yellow"
      end
    end
  end
end
