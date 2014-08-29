require "spec_helper"
describe ReminderMessage do
  fixtures :participants, :users, :reminder_messages, :first_contacts, :first_appointments

  describe "Message Scheduler" do
    context "First Contact for Portuguese" do
      let(:portuguese_participant) { participants(:portuguese_active_participant) }
      let(:first_contact) { first_contacts(:portuguese_first_contact) }
      let(:first_appointment) { first_appointments(:portuguese_first_appointment) }

      describe "#schedule_message" do
        it "schedules all reminder messages for an upcoming first appointment" do
          
          first_contact.schedule_message(portuguese_participant, "appointment")

          expect(ReminderMessage.where(participant: portuguese_participant,
                                       notify_at: "24",
                                       message_type: "nurse",
                                       appointment_type: "appointment"
                                       )).to exist

          expect(ReminderMessage.where(participant: portuguese_participant,
                                       notify_at: "24",
                                       message_type: "participant",
                                       appointment_type: "appointment"
                                       )).to exist

          expect(ReminderMessage.where(participant: portuguese_participant,
                                       notify_at: "1",
                                       message_type: "nurse",
                                       appointment_type: "appointment"
                                       )).to exist

          expect(ReminderMessage.where(participant: portuguese_participant,
                                       notify_at: "1",
                                       message_type: "participant",
                                       appointment_type: "appointment"
                                       )).to exist
        end

        it "does not schedule a 1 hour reminder for participants for phone appointments" do
          first_appointment.schedule_message(portuguese_participant, "contact")

          expect(ReminderMessage.where(participant: portuguese_participant,
                                       notify_at: "1",
                                       message_type: "participant",
                                       appointment_type: "second_contact"
                                       )).to_not exist
        end
      end

      describe "#schedule_24_hour" do
        it "schedules a 24 appointment" do
          first_contact.schedule_24_hour("participant",
                                         "appointment",
                                         portuguese_participant
                                        )
          expect(ReminderMessage.where(participant: portuguese_participant,
                                       notify_at: "24",
                                       message_type: "participant",
                                       appointment_type: "appointment"
                                       )).to exist
        end
      end

      describe "#schedule_1_hour" do
        it "schedules a 1 hour appointment" do
          first_contact.schedule_1_hour("participant",
                                        "appointment",
                                        portuguese_participant
                                        )
          expect(ReminderMessage.where(participant: portuguese_participant,
                                       notify_at: "1",
                                       message_type: "participant",
                                       appointment_type: "appointment"
                                       )).to exist
        end
      end
    end

    describe "Rescheduling a first appointment" do
      context "before notification sent" do
        let(:participant) { participants(:active_participant) }
        let(:first_contact) { first_contacts(:first_contact) }
        it "updates notification time of upcoming reminder messages for first appointment" do
          
          first_contact.schedule_message(participant, "appointment")
          first_appointment_one_hour = ReminderMessage.where(participant: participant,
                                       notify_at: "1",
                                       message_type: "participant",
                                       appointment_type: "appointment",
                                       status: "pending"
                                       ).first
          
          old_one_hour_time = first_appointment_one_hour.notification_time
          
          first_contact.update(first_appointment_at: DateTime.current + 3.days)
          
          new_one_hour_time = ReminderMessage.where(participant: participant,
                                       notify_at: "1",
                                       message_type: "participant",
                                       appointment_type: "appointment",
                                       status: "pending"
                                       ).first
                                        .notification_time
          expect(old_one_hour_time).to_not eq(new_one_hour_time)
        end
      end
      
      context "after notification sent" do
        let(:participant) { participants(:active_participant) }
        let(:first_contact) { first_contacts(:first_contact) }
        it "updates notification time of past reminder messages for first appointment and makes them pending" do
          
          first_contact.schedule_message(participant, "appointment")
          first_appointment_one_hour = ReminderMessage.where(participant: participant,
                                       notify_at: "1",
                                       message_type: "participant",
                                       appointment_type: "appointment"
                                       ).first
          
          first_appointment_one_hour.update_attribute(:status, "sent")

          expect(first_appointment_one_hour.status).to eq("sent")

          first_appointment_one_hour.requeue

          expect(first_appointment_one_hour.status).to eq("pending")

          first_contact.update(first_appointment_at: DateTime.current + 3.days)

          first_contact.schedule_message(participant, "appointment")
          
          expect(first_appointment_one_hour.status).to eq("pending")

        end
      end
    end
  end

  describe "Reminder Message" do
    
    describe "#notification_time" do
      context "24 hour first contact" do
        let(:portuguese_participant) { participants(:portuguese_active_participant) }
        let(:es_participant) { participants(:es_active_participant) }
        let(:first_contact) { first_contacts(:portuguese_first_contact) }

        it "returns a datetime 24 hours before the first appointment" do
          first_contact.schedule_24_hour("participant",
                                         "appointment",
                                         portuguese_participant
                                        )
          message = ReminderMessage.where(participant: portuguese_participant,
                                          notify_at: "24",
                                          message_type: "participant",
                                          appointment_type: "appointment"
                                         ).first
          expect(message.notification_time).to eq(first_contact.first_appointment_at - 1.day)
        end
      end
    end

    describe "#message" do
      context "24 hour first contact for portuguese participant" do
        let(:pt_reminder_message) { reminder_messages(:pt_first_participant_24_pending) }
        let(:es_reminder_message) { reminder_messages(:es_second_nurse_24_pending) }

        it "returns the correct appointment message for participant" do
          message = pt_reminder_message.message
          expected_message = ReminderMessage::MESSAGES[:pt_BR][:participant][:appointment][:hour_24]
          expect(message).to eq(expected_message)
        end

        it "returns the correct second_contact message for nurse" do
          message = es_reminder_message.message
          expected_message = "#{ReminderMessage::MESSAGES[:es_PE][:nurse][:second_contact][:hour_24]} -- #{es_reminder_message.participant.study_identifier}"
          expect(message).to eq(expected_message)
        end
      end
    end
  end
end