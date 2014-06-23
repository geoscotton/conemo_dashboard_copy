require "spec_helper"
describe ReminderMessage do
  fixtures :participants, :users, :reminder_messages, :first_contacts

  describe "Message Scheduler" do
    context "First Contact for Portuguese participant" do
      let(:portuguese_participant) { participants(:portuguese_active_participant) }
      let(:first_contact) { first_contacts(:portuguese_first_contact) }

      describe "#schedule_24_hour" do
        it "schedules a 24 appointment" do
          first_contact.schedule_24_hour("participant",
                                         "contact",
                                         portuguese_participant
                                        )
          expect(ReminderMessage.where(participant: portuguese_participant,
                                       notify_at: "24",
                                       message_type: "participant",
                                       appointment_type: "contact"
                                       )).to exist
        end
      end

      describe "#schedule_1_hour" do
        it "schedules a 1 hour appointment" do
          first_contact.schedule_1_hour("participant",
                                        "contact",
                                        portuguese_participant
                                        )
          expect(ReminderMessage.where(participant: portuguese_participant,
                                       notify_at: "1",
                                       message_type: "participant",
                                       appointment_type: "contact"
                                       )).to exist
        end
      end
    end
    describe "Rescheduling a first appointment" do
      context "before notification sent" do
        let(:participant) { participants(:active_participant) }
        let(:first_contact) { first_contacts(:first_contact) }
        it "updates notification time of upcoming reminder messages for first appointment" do
          
          first_contact.schedule_message(participant, "contact")
          first_appointment_one_hour = ReminderMessage.where(participant: participant,
                                       notify_at: "1",
                                       message_type: "participant",
                                       appointment_type: "contact"
                                       ).first
          
          old_one_hour_time = first_appointment_one_hour.notification_time
          
          first_contact.update(first_appointment_at: DateTime.current + 3.days)
          
          new_one_hour_time = ReminderMessage.where(participant: participant,
                                       notify_at: "1",
                                       message_type: "participant",
                                       appointment_type: "contact"
                                       ).first
                                        .notification_time
          expect(old_one_hour_time).to_not eq(new_one_hour_time)
        end
      end
    end
  end

  describe "Reminder Message" do
    describe "#notification_time" do
      context "24 hour first contact" do
        let(:portuguese_participant) { participants(:portuguese_active_participant) }
        let(:first_contact) { first_contacts(:portuguese_first_contact) }

        it "returns a datetime 24 hours before the first appointment" do
          first_contact.schedule_24_hour("participant",
                                         "contact",
                                         portuguese_participant
                                        )
          message = ReminderMessage.where(participant: portuguese_participant,
                                          notify_at: "24",
                                          message_type: "participant",
                                          appointment_type: "contact"
                                         ).first
          expect(message.notification_time).to eq(first_contact.first_appointment_at - 1.day)
        end
      end
    end
    describe "#message" do
      context "24 hour first contact for portuguese participant" do
        let(:reminder_message) { reminder_messages(:pt_first_participant_24) }

        it "returns the correct message" do
          message = reminder_message.message

          expect(message).to eq(ReminderMessage::MESSAGES[:pt_BR][:participant][:contact][:hour_24])
        end
      end
    end
  end
end