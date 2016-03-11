# frozen_string_literal: true
require "rails_helper"

module Concerns
  class MockParticipant
    include Status

    attr_reader :study_day, :locale, :content_access_events, :session_events

    def initialize(study_day:, locale: "en", content_access_events: nil,
                   session_events: nil)
      @study_day = study_day
      @locale = locale
      @content_access_events = content_access_events
      @session_events = session_events
    end
  end

  RSpec.describe Status do
    describe "#lesson_status" do
      let(:started_participant) { MockParticipant.new(study_day: 3) }
      let(:statuses) { Status::LESSON_STATUSES }

      context "when the lesson is nil" do
        it "returns 'un-released'" do
          expect(started_participant.lesson_status(nil)).to eq statuses.unreleased
        end
      end

      context "when the lesson will be available " \
              "after the current study day" do
        it "returns un-released" do
          lesson = instance_double(Lesson, day_in_treatment: 5)

          expect(started_participant.lesson_status(lesson))
            .to eq statuses.unreleased
        end
      end

      context "when the study_day is nil" do
        it "returns 'un-released'" do
          unstarted_participant = MockParticipant.new(study_day: nil)
          lesson = instance_double(Lesson, day_in_treatment: 5)

          expect(unstarted_participant.lesson_status(lesson))
            .to eq statuses.unreleased
        end
      end

      context "when the lesson is available on the current study day" do
        let(:guid) { "guid" }
        let(:lesson) do
          instance_double(Lesson,
                          id: rand(100),
                          guid: guid,
                          day_in_treatment: started_participant.study_day)
        end
        let(:completion_events) { double("completion events") }
        let(:access_events) { double("access events") }
        let(:participant) do
          MockParticipant.new(study_day: 4,
                              content_access_events: completion_events,
                              session_events: access_events)
        end

        context "and the lesson is the current lesson" do
          it "returns 'info'" do
            allow(access_events).to receive_message_chain("where.order")
              .and_return([])
            allow(completion_events)
              .to receive(:find_by).with(lesson_id: lesson.id)
              .and_return(nil)
            allow(Lesson).to receive_message_chain("where.where.order")
              .and_return([lesson])

            expect(participant.lesson_status(lesson)).to eq statuses.info
          end
        end

        context "and the lesson is not the current lesson" do
          context "and the lesson has not been accessed" do
            context "and the next lesson has been released" do
              it "returns 'danger'" do
                current_lesson = instance_double(Lesson,
                                                 guid: guid + "_abcd",
                                                 day_in_treatment: 1)
                allow(access_events).to receive_message_chain("where.order")
                  .and_return([])
                allow(completion_events)
                  .to receive(:find_by).with(lesson_id: lesson.id)
                  .and_return(nil)
                allow(Lesson).to receive_message_chain("where.where.order")
                  .and_return([current_lesson])

                expect(participant.lesson_status(lesson)).to eq statuses.danger
              end
            end
          end

          context "and the lesson has been accessed" do
            context "and the completion was late" do
              it "returns 'warning'" do
                current_lesson = instance_double(Lesson,
                                                 guid: guid + "_abcd",
                                                 day_in_treatment: 1)
                access = instance_double(SessionEvent)
                late_completion = instance_double(ContentAccessEvent,
                                                  late?: true)
                allow(access_events).to receive_message_chain("where.order")
                  .and_return([access])
                allow(completion_events)
                  .to receive(:find_by).with(lesson_id: lesson.id)
                  .and_return(late_completion)
                allow(Lesson).to receive_message_chain("where.where.order")
                  .and_return([current_lesson])

                expect(participant.lesson_status(lesson))
                  .to eq statuses.completed_late
              end
            end

            context "and the lesson was not completed" do
              it "returns 'accessed'" do
                current_lesson = instance_double(Lesson,
                                                 guid: guid + "_abcd",
                                                 day_in_treatment: 1)
                access = instance_double(SessionEvent)
                allow(completion_events)
                  .to receive(:find_by).with(lesson_id: lesson.id)
                  .and_return(nil)
                allow(access_events).to receive_message_chain("where.order")
                  .and_return([access])
                allow(Lesson).to receive_message_chain("where.where.order")
                  .and_return([current_lesson])

                expect(participant.lesson_status(lesson))
                  .to eq statuses.accessed_incomplete
              end

              context "and the lesson was completed on time" do
                it "returns 'success'" do
                  current_lesson = instance_double(Lesson,
                                                   guid: guid + "_abcd",
                                                   day_in_treatment: 1)
                  access = instance_double(SessionEvent)
                  on_time_completion = instance_double(ContentAccessEvent,
                                                       late?: false)
                  allow(access_events).to receive_message_chain("where.order")
                    .and_return([access])
                  allow(completion_events)
                    .to receive(:find_by).with(lesson_id: lesson.id)
                    .and_return(on_time_completion)
                  allow(Lesson).to receive_message_chain("where.where.order")
                    .and_return([current_lesson])

                  expect(participant.lesson_status(lesson))
                    .to eq statuses.completed_on_time
                end
              end
            end
          end
        end
      end
    end
  end
end
