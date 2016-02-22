require "spec_helper"

RSpec.describe ReminderMessage, type: :model do
  fixtures :all

  describe "Message Scheduler" do
    context "First Contact for Portuguese" do
      let(:portuguese_participant) { participants(:portuguese_active_participant) }
      let(:first_contact) { first_contacts(:portuguese_first_contact) }
      let(:first_appointment) { first_appointments(:portuguese_first_appointment) }

      describe "#schedule_message" do
        it "schedules all reminder messages for an upcoming first appointment" do

          first_contact.schedule_message(portuguese_participant, ReminderMessage::APPOINTMENT)

          expect(ReminderMessage.where(participant: portuguese_participant,
                                       notify_at: "24",
                                       message_type: ReminderMessage::NURSE,
                                       appointment_type: ReminderMessage::APPOINTMENT
                                       )).to exist

          expect(ReminderMessage.where(participant: portuguese_participant,
                                       notify_at: "24",
                                       message_type: ReminderMessage::PARTICIPANT,
                                       appointment_type: ReminderMessage::APPOINTMENT
                                       )).to exist

          expect(ReminderMessage.where(participant: portuguese_participant,
                                       notify_at: "1",
                                       message_type: ReminderMessage::NURSE,
                                       appointment_type: ReminderMessage::APPOINTMENT
                                       )).to exist

          expect(ReminderMessage.where(participant: portuguese_participant,
                                       notify_at: "1",
                                       message_type: ReminderMessage::PARTICIPANT,
                                       appointment_type: ReminderMessage::APPOINTMENT
                                       )).to exist
        end

        it "does not schedule a 1 hour reminder for participants for phone appointments" do
          first_appointment.schedule_message(portuguese_participant, "contact")

          expect(ReminderMessage.where(participant: portuguese_participant,
                                       notify_at: "1",
                                       message_type: ReminderMessage::PARTICIPANT,
                                       appointment_type: "second_contact"
                                       )).to_not exist
        end
      end

      describe "#schedule_24_hour" do
        it "schedules a 24 appointment" do
          first_contact.schedule_24_hour(ReminderMessage::PARTICIPANT,
                                         ReminderMessage::APPOINTMENT,
                                         portuguese_participant
                                        )
          expect(ReminderMessage.where(participant: portuguese_participant,
                                       notify_at: "24",
                                       message_type: ReminderMessage::PARTICIPANT,
                                       appointment_type: ReminderMessage::APPOINTMENT
                                       )).to exist
        end
      end

      describe "#schedule_1_hour" do
        it "schedules a 1 hour appointment" do
          first_contact.schedule_1_hour(ReminderMessage::PARTICIPANT,
                                        ReminderMessage::APPOINTMENT,
                                        portuguese_participant
                                        )
          expect(ReminderMessage.where(participant: portuguese_participant,
                                       notify_at: "1",
                                       message_type: ReminderMessage::PARTICIPANT,
                                       appointment_type: ReminderMessage::APPOINTMENT
                                       )).to exist
        end
      end
    end

    describe "Rescheduling a first appointment" do
      context "before notification sent" do
        let(:participant) { participants(:active_participant) }
        let(:first_contact) { first_contacts(:first_contact) }
        it "updates notification time of upcoming reminder messages for first appointment" do

          first_contact.schedule_message(participant, ReminderMessage::APPOINTMENT)
          first_appointment_one_hour = ReminderMessage.where(participant: participant,
                                       notify_at: "1",
                                       message_type: ReminderMessage::PARTICIPANT,
                                       appointment_type: ReminderMessage::APPOINTMENT,
                                       status: "pending"
                                       ).first

          old_one_hour_time = first_appointment_one_hour.notification_time

          first_contact.update(first_appointment_at: DateTime.current + 3.days)

          new_one_hour_time = ReminderMessage.where(
            participant: participant,
            notify_at: "1",
            message_type: ReminderMessage::PARTICIPANT,
            appointment_type: ReminderMessage::APPOINTMENT,
            status: "pending"
          ).first.notification_time

          expect(old_one_hour_time).to_not eq(new_one_hour_time)
        end
      end

      context "after notification sent" do
        let(:participant) { participants(:active_participant) }
        let(:first_contact) { first_contacts(:first_contact) }
        it "updates notification time of past reminder messages for first appointment and makes them pending" do

          first_contact.schedule_message(participant, ReminderMessage::APPOINTMENT)
          first_appointment_one_hour = ReminderMessage.where(participant: participant,
                                       notify_at: "1",
                                       message_type: ReminderMessage::PARTICIPANT,
                                       appointment_type: ReminderMessage::APPOINTMENT
                                       ).first

          first_appointment_one_hour.update_attribute(:status, "sent")

          expect(first_appointment_one_hour.status).to eq("sent")

          first_appointment_one_hour.requeue

          expect(first_appointment_one_hour.status).to eq("pending")

          first_contact.update(first_appointment_at: DateTime.current + 3.days)

          first_contact.schedule_message(participant, ReminderMessage::APPOINTMENT)

          expect(first_appointment_one_hour.status).to eq("pending")

        end
      end
    end
  end

  describe "#notification_time" do
    let(:portuguese_participant) { participants(:portuguese_active_participant) }
    let(:second_contact) { second_contacts(:portuguese_second_contact) }
    let(:third_contact) { third_contacts(:portuguese_third_contact) }

    def find_reminder_message(notify_at:, appointment_type:)
      ReminderMessage.find_by(
        participant: portuguese_participant,
        notify_at: notify_at,
        message_type: ReminderMessage::PARTICIPANT,
        appointment_type: appointment_type
      )
    end

    context "24 hour first contact" do
      let(:first_contact) { first_contacts(:portuguese_first_contact) }

      it "returns a datetime 24 hours before the first appointment" do
        first_contact.schedule_24_hour(ReminderMessage::PARTICIPANT,
                                       ReminderMessage::APPOINTMENT,
                                       portuguese_participant
                                      )
        message = ReminderMessage.where(participant: portuguese_participant,
                                        notify_at: "24",
                                        message_type: ReminderMessage::PARTICIPANT,
                                        appointment_type: ReminderMessage::APPOINTMENT
                                       ).first
        expect(message.notification_time).to eq(first_contact.first_appointment_at - 1.day)
      end
    end

    context "for second contact" do
      let(:first_appointment) { first_appointments(:portuguese_first_appointment) }

      context "at 1 hour" do
        it "returns a time 1 hour before the second contact" do
          second_contact.schedule_1_hour(
            ReminderMessage::PARTICIPANT,
            ReminderMessage::SECOND_CONTACT,
            portuguese_participant
          )
          message = find_reminder_message(
            notify_at: ReminderMessage::ONE_HOUR,
            appointment_type: ReminderMessage::SECOND_CONTACT
          )

          expect(message.notification_time)
            .to eq(first_appointment.next_contact - 1.hour)
        end
      end

      context "at 1 day" do
        it "returns a time 1 day before the second contact" do
          second_contact.schedule_24_hour(
            ReminderMessage::PARTICIPANT,
            ReminderMessage::SECOND_CONTACT,
            portuguese_participant
          )
          message = find_reminder_message(
            notify_at: ReminderMessage::ONE_DAY,
            appointment_type: ReminderMessage::SECOND_CONTACT
          )

          expect(message.notification_time)
            .to eq(first_appointment.next_contact - 1.day)
        end
      end
    end

    context "for third contact" do
      context "at 1 hour" do
        it "returns a time 1 hour before the third contact" do
          third_contact.schedule_1_hour(
            ReminderMessage::PARTICIPANT,
            ReminderMessage::THIRD_CONTACT,
            portuguese_participant
          )
          message = find_reminder_message(
            notify_at: ReminderMessage::ONE_HOUR,
            appointment_type: ReminderMessage::THIRD_CONTACT
          )

          expect(message.notification_time)
            .to eq(second_contact.next_contact - 1.hour)
        end
      end

      context "at 1 day" do
        it "returns a time 1 day before the third contact" do
          second_contact.schedule_24_hour(
            ReminderMessage::PARTICIPANT,
            ReminderMessage::THIRD_CONTACT,
            portuguese_participant
          )
          message = find_reminder_message(
            notify_at: ReminderMessage::ONE_DAY,
            appointment_type: ReminderMessage::THIRD_CONTACT
          )

          expect(message.notification_time)
            .to eq(second_contact.next_contact - 1.day)
        end
      end
    end

    context "for final appointment" do
      context "at 1 hour" do
        it "returns a time 1 hour before the final appointment" do
          third_contact.schedule_1_hour(
            ReminderMessage::PARTICIPANT,
            ReminderMessage::FINAL_APPOINTMENT,
            portuguese_participant
          )
          message = find_reminder_message(
            notify_at: ReminderMessage::ONE_HOUR,
            appointment_type: ReminderMessage::FINAL_APPOINTMENT
          )

          expect(message.notification_time)
            .to eq(third_contact.call_to_schedule_final_appointment_at - 1.hour)
        end
      end

      context "at 1 day" do
        it "returns a time 1 day before the final appointment" do
          second_contact.schedule_24_hour(
            ReminderMessage::PARTICIPANT,
            ReminderMessage::FINAL_APPOINTMENT,
            portuguese_participant
          )
          message = find_reminder_message(
            notify_at: ReminderMessage::ONE_DAY,
            appointment_type: ReminderMessage::FINAL_APPOINTMENT
          )

          expect(message.notification_time)
            .to eq(third_contact.call_to_schedule_final_appointment_at - 1.day)
        end
      end
    end
  end

  describe "#message" do
    context "24 hour first contact for various participant locales" do
      let(:pt_reminder_message) { reminder_messages(:pt_first_participant_24_pending) }
      let(:es_reminder_message) { reminder_messages(:es_second_nurse_24_pending) }
      let(:en_reminder_message) { reminder_messages(:en_appointment_participant_24_pending) }

      it "returns the correct first appointment message for portuguese participant part a" do
        message = pt_reminder_message.message("part_a")
        expected_message = ReminderMessage::MESSAGES[:pt_BR][:participant][:appointment][:hour_24][:part_a]
        expect(message).to eq(expected_message)
      end

      it "returns the correct first appointment message for portuguese participant part b" do
        message = pt_reminder_message.message("part_b")
        expected_message = ReminderMessage::MESSAGES[:pt_BR][:participant][:appointment][:hour_24][:part_b]
        expect(message).to eq(expected_message)
      end

      it "returns the correct final appointment message for english participant part a" do
        message = en_reminder_message.message("part_a")
        expected_message = ReminderMessage::MESSAGES[:en][:participant][:final][:hour_24][:part_a]
        expect(message).to eq(expected_message)
      end

      it "returns the correct final appointment message for english participant part b" do
        message = en_reminder_message.message("part_b")
        expected_message = ReminderMessage::MESSAGES[:en][:participant][:final][:hour_24][:part_b]
        expect(message).to eq(expected_message)
      end

      it "returns the correct second_contact message for nurse" do
        message = es_reminder_message.message
        expected_message = "#{ReminderMessage::MESSAGES[:es_PE][:nurse][:second_contact][:hour_24]} -- #{es_reminder_message.participant.study_identifier}"
        expect(message).to eq(expected_message)
      end
    end
  end

  describe "#split_message" do
    context "when the locale is 'es-PE'" do
      it "returns false" do
        expect(ReminderMessage.new(
          participant: participants(:portuguese_active_participant)
        ).split_message).to be false
      end
    end

    context "when the locale is not 'es-PE'" do
      let(:non_es_locales) do
        [:english_active_participant, :portuguese_active_participant]
      end

      context "and the notification is at 1 day" do
        context "and the appointment is a first appointment" do
          it "returns true" do
            non_es_locales.each do |p_type|
              expect(ReminderMessage.new(
                participant: participants(p_type),
                appointment_type: ReminderMessage::APPOINTMENT,
                notify_at: ReminderMessage::ONE_DAY
              ).split_message).to be true
            end
          end
        end

        context "and the appointment is a final appointment" do
          it "returns true" do
            non_es_locales.each do |p_type|
              expect(ReminderMessage.new(
                participant: participants(p_type),
                appointment_type: ReminderMessage::FINAL_APPOINTMENT,
                notify_at: ReminderMessage::ONE_DAY
              ).split_message).to be true
            end
          end
        end

        context "and the appointment is not a first or final appointment" do
          it "returns false" do
            non_first_or_final = [
              ReminderMessage::THIRD_CONTACT,
              ReminderMessage::SECOND_CONTACT
            ]

            non_es_locales.each do |p_type|
              expect(ReminderMessage.new(
                participant: participants(p_type),
                appointment_type: non_first_or_final.sample,
                notify_at: ReminderMessage::ONE_DAY
              ).split_message).to be false
            end
          end
        end
      end

      context "and the notification is not at 1 day" do
        it "returns false" do
          non_es_locales.each do |p_type|
            expect(ReminderMessage.new(
              participant: participants(p_type),
              appointment_type: ReminderMessage::APPOINTMENT_TYPES.sample,
              notify_at: ReminderMessage::ONE_HOUR
            ).split_message).to be false
          end
        end
      end
    end
  end
end
