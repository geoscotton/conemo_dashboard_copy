# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160802194003) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "additional_contacts", force: :cascade do |t|
    t.integer  "participant_id", null: false
    t.datetime "scheduled_at",   null: false
    t.string   "kind",           null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "additional_contacts", ["participant_id"], name: "index_additional_contacts_on_participant_id", using: :btree

  create_table "bit_core_content_modules", force: :cascade do |t|
    t.string   "title",                        null: false
    t.integer  "position",         default: 1, null: false
    t.integer  "bit_core_tool_id",             null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bit_core_content_modules", ["bit_core_tool_id", "position"], name: "bit_core_content_module_position", unique: true, using: :btree

  create_table "bit_core_content_providers", force: :cascade do |t|
    t.string   "type",                                   null: false
    t.string   "source_content_type"
    t.integer  "source_content_id"
    t.integer  "bit_core_content_module_id",             null: false
    t.integer  "position",                   default: 1, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bit_core_content_providers", ["bit_core_content_module_id", "position"], name: "bit_core_content_provider_position", unique: true, using: :btree

  create_table "bit_core_slides", force: :cascade do |t|
    t.string   "title",                                null: false
    t.text     "body",                                 null: false
    t.integer  "position",              default: 1,    null: false
    t.integer  "bit_core_slideshow_id",                null: false
    t.string   "type"
    t.boolean  "is_title_visible",      default: true, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bit_core_slides", ["bit_core_slideshow_id", "position"], name: "bit_core_slide_position", unique: true, using: :btree

  create_table "bit_core_slideshows", force: :cascade do |t|
    t.string   "title",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bit_core_tools", force: :cascade do |t|
    t.string   "title",                  null: false
    t.integer  "position",   default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bit_core_tools", ["position"], name: "bit_core_tool_position", unique: true, using: :btree

  create_table "call_to_schedule_final_appointments", force: :cascade do |t|
    t.integer  "participant_id",             null: false
    t.datetime "contact_at",                 null: false
    t.datetime "final_appointment_at",       null: false
    t.string   "final_appointment_location", null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "call_to_schedule_final_appointments", ["participant_id"], name: "index_call_to_schedule_final_appointments_on_participant_id", unique: true, using: :btree

  create_table "content_access_events", force: :cascade do |t|
    t.integer  "participant_id",            null: false
    t.datetime "accessed_at",               null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lesson_id",                 null: false
    t.integer  "day_in_treatment_accessed", null: false
    t.string   "lesson_datum_guid"
    t.string   "dialogue_datum_guid"
    t.string   "uuid",                      null: false
    t.datetime "client_created_at"
    t.datetime "client_updated_at"
  end

  add_index "content_access_events", ["lesson_id"], name: "index_content_access_events_on_lesson_id", using: :btree
  add_index "content_access_events", ["participant_id"], name: "index_content_access_events_on_participant_id", using: :btree

  create_table "devices", force: :cascade do |t|
    t.string   "uuid",              null: false
    t.string   "device_uuid",       null: false
    t.string   "manufacturer",      null: false
    t.string   "model",             null: false
    t.string   "platform",          null: false
    t.string   "device_version",    null: false
    t.datetime "inserted_at",       null: false
    t.integer  "participant_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.datetime "last_seen_at",      null: false
    t.datetime "client_created_at"
    t.datetime "client_updated_at"
  end

  add_index "devices", ["device_uuid", "participant_id"], name: "index_devices_on_device_uuid_and_participant_id", unique: true, using: :btree
  add_index "devices", ["uuid"], name: "index_devices_on_uuid", unique: true, using: :btree

  create_table "final_appointments", force: :cascade do |t|
    t.datetime "appointment_at"
    t.string   "appointment_location"
    t.boolean  "phone_returned",       null: false
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "participant_id"
  end

  create_table "first_appointments", force: :cascade do |t|
    t.integer  "participant_id",       null: false
    t.datetime "appointment_at",       null: false
    t.string   "appointment_location"
    t.integer  "session_length",       null: false
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "first_appointments", ["participant_id"], name: "index_first_appointments_on_participant_id", using: :btree

  create_table "first_contacts", force: :cascade do |t|
    t.integer  "participant_id",             null: false
    t.datetime "contact_at",                 null: false
    t.datetime "first_appointment_at",       null: false
    t.string   "first_appointment_location"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "first_contacts", ["participant_id"], name: "index_first_contacts_on_participant_id", using: :btree

  create_table "help_messages", force: :cascade do |t|
    t.integer  "participant_id",     null: false
    t.text     "message",            null: false
    t.string   "staff_message_guid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "sent_at",            null: false
    t.string   "uuid",               null: false
    t.datetime "client_created_at"
    t.datetime "client_updated_at"
  end

  add_index "help_messages", ["participant_id"], name: "index_help_messages_on_participant_id", using: :btree

  create_table "help_request_calls", force: :cascade do |t|
    t.integer  "participant_id", null: false
    t.datetime "contact_at",     null: false
    t.string   "explanation",    null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "help_request_calls", ["participant_id"], name: "index_help_request_calls_on_participant_id", using: :btree

  create_table "lack_of_connectivity_calls", force: :cascade do |t|
    t.integer  "participant_id", null: false
    t.datetime "contact_at",     null: false
    t.string   "explanation",    null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "lack_of_connectivity_calls", ["participant_id"], name: "index_lack_of_connectivity_calls_on_participant_id", using: :btree

  create_table "lessons", force: :cascade do |t|
    t.string   "title",                                         null: false
    t.integer  "bit_core_slideshow_id"
    t.integer  "day_in_treatment",              default: 1,     null: false
    t.string   "locale",                        default: "en",  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "guid",                                          null: false
    t.boolean  "has_activity_planning",         default: false, null: false
    t.string   "pre_planning_content"
    t.string   "post_planning_content"
    t.string   "non_planning_content"
    t.integer  "feedback_after_days"
    t.string   "planning_response_yes_content"
    t.string   "planning_response_no_content"
    t.string   "non_planning_response_content"
    t.text     "activity_choices"
  end

  add_index "lessons", ["bit_core_slideshow_id"], name: "index_lessons_on_bit_core_slideshow_id", using: :btree

  create_table "logins", force: :cascade do |t|
    t.integer  "participant_id",    null: false
    t.datetime "logged_in_at",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "app_login_guid"
    t.string   "uuid",              null: false
    t.string   "app_version"
    t.datetime "client_created_at"
    t.datetime "client_updated_at"
  end

  add_index "logins", ["participant_id"], name: "index_logins_on_participant_id", using: :btree

  create_table "non_adherence_calls", force: :cascade do |t|
    t.integer  "participant_id", null: false
    t.datetime "contact_at",     null: false
    t.string   "explanation",    null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "non_adherence_calls", ["participant_id"], name: "index_non_adherence_calls_on_participant_id", using: :btree

  create_table "nurse_tasks", force: :cascade do |t|
    t.integer  "participant_id",                    null: false
    t.string   "type",                              null: false
    t.string   "status",         default: "active", null: false
    t.datetime "scheduled_at",                      null: false
    t.datetime "overdue_at",                        null: false
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  add_index "nurse_tasks", ["participant_id"], name: "index_nurse_tasks_on_participant_id", using: :btree

  create_table "participant_start_dates", force: :cascade do |t|
    t.date     "date",              null: false
    t.string   "uuid",              null: false
    t.integer  "participant_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.datetime "client_created_at"
    t.datetime "client_updated_at"
  end

  add_index "participant_start_dates", ["participant_id"], name: "index_participant_start_dates_on_participant_id", using: :btree

  create_table "participants", force: :cascade do |t|
    t.integer  "nurse_id"
    t.string   "first_name",                                                  null: false
    t.string   "last_name",                                                   null: false
    t.string   "study_identifier",                                            null: false
    t.string   "family_health_unit_name",                                     null: false
    t.string   "phone"
    t.text     "address",                                                     null: false
    t.date     "date_of_birth"
    t.string   "gender",                                                      null: false
    t.string   "status",                               default: "unassigned", null: false
    t.string   "emergency_contact_name"
    t.string   "emergency_contact_phone"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "locale",                                                      null: false
    t.string   "alternate_phone_1"
    t.string   "alternate_phone_2"
    t.string   "contact_person_1_name"
    t.string   "contact_person_1_relationship"
    t.string   "contact_person_1_other_relationship"
    t.string   "contact_person_2_name"
    t.string   "contact_person_2_relationship"
    t.string   "contact_person_2_other_relationship"
    t.string   "emergency_contact_relationship"
    t.string   "emergency_contact_other_relationship"
    t.string   "emergency_contact_address"
    t.string   "emergency_contact_cell_phone"
    t.string   "cell_phone"
  end

  add_index "participants", ["nurse_id"], name: "index_participants_on_nurse_id", using: :btree

  create_table "past_device_assignments", force: :cascade do |t|
    t.string   "uuid"
    t.string   "device_uuid"
    t.string   "manufacturer"
    t.string   "model"
    t.string   "platform"
    t.string   "device_version"
    t.datetime "inserted_at"
    t.integer  "participant_id"
    t.datetime "last_seen_at"
    t.datetime "client_created_at"
    t.datetime "client_updated_at"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "patient_contacts", force: :cascade do |t|
    t.string   "contact_reason"
    t.text     "note"
    t.datetime "contact_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "participant_id"
    t.integer  "first_contact_id"
    t.integer  "first_appointment_id"
    t.integer  "second_contact_id"
    t.integer  "third_contact_id"
  end

  add_index "patient_contacts", ["first_appointment_id"], name: "index_patient_contacts_on_first_appointment_id", using: :btree
  add_index "patient_contacts", ["first_contact_id"], name: "index_patient_contacts_on_first_contact_id", using: :btree
  add_index "patient_contacts", ["participant_id"], name: "index_patient_contacts_on_participant_id", using: :btree
  add_index "patient_contacts", ["second_contact_id"], name: "index_patient_contacts_on_second_contact_id", using: :btree
  add_index "patient_contacts", ["third_contact_id"], name: "index_patient_contacts_on_third_contact_id", using: :btree

  create_table "planned_activities", force: :cascade do |t|
    t.string   "uuid",               null: false
    t.integer  "participant_id",     null: false
    t.string   "name",               null: false
    t.boolean  "is_complete"
    t.boolean  "is_help_wanted"
    t.string   "level_of_happiness"
    t.string   "how_worthwhile"
    t.datetime "planned_at",         null: false
    t.string   "lesson_guid",        null: false
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.datetime "client_created_at"
    t.datetime "client_updated_at"
    t.datetime "follow_up_at"
  end

  create_table "responses", force: :cascade do |t|
    t.integer  "content_access_event_id"
    t.text     "answer",                  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "responses", ["content_access_event_id"], name: "index_responses_on_content_access_event_id", using: :btree

  create_table "scheduled_task_cancellations", force: :cascade do |t|
    t.integer  "nurse_task_id", null: false
    t.string   "explanation",   null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "scheduled_task_cancellations", ["nurse_task_id"], name: "index_scheduled_task_cancellations_on_nurse_task_id", unique: true, using: :btree

  create_table "scheduled_task_reschedulings", force: :cascade do |t|
    t.integer  "nurse_task_id",    null: false
    t.string   "explanation",      null: false
    t.datetime "old_scheduled_at", null: false
    t.datetime "scheduled_at",     null: false
    t.text     "notes"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "scheduled_task_reschedulings", ["nurse_task_id"], name: "index_scheduled_task_reschedulings_on_nurse_task_id", using: :btree

  create_table "second_contacts", force: :cascade do |t|
    t.integer  "participant_id", null: false
    t.datetime "contact_at",     null: false
    t.integer  "session_length", null: false
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "difficulties"
  end

  add_index "second_contacts", ["participant_id"], name: "index_second_contacts_on_participant_id", using: :btree

  create_table "session_events", force: :cascade do |t|
    t.integer  "participant_id",    null: false
    t.string   "event_type",        null: false
    t.datetime "occurred_at",       null: false
    t.integer  "lesson_id",         null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "uuid",              null: false
    t.datetime "client_created_at"
    t.datetime "client_updated_at"
  end

  add_index "session_events", ["lesson_id"], name: "index_session_events_on_lesson_id", using: :btree
  add_index "session_events", ["participant_id"], name: "index_session_events_on_participant_id", using: :btree

  create_table "smartphones", force: :cascade do |t|
    t.string   "number",           null: false
    t.integer  "participant_id",   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "phone_identifier", null: false
  end

  add_index "smartphones", ["participant_id"], name: "index_smartphones_on_participant_id", using: :btree

  create_table "supervision_sessions", force: :cascade do |t|
    t.datetime "session_at",     null: false
    t.integer  "session_length", null: false
    t.string   "meeting_kind",   null: false
    t.string   "contact_kind",   null: false
    t.integer  "nurse_id",       null: false
    t.text     "topics"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "supervision_sessions", ["nurse_id"], name: "index_supervision_sessions_on_nurse_id", using: :btree

  create_table "supervisor_notes", force: :cascade do |t|
    t.text     "note",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "nurse_id"
  end

  create_table "supervisor_notifications", force: :cascade do |t|
    t.integer  "nurse_task_id",                    null: false
    t.string   "status",        default: "active", null: false
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  add_index "supervisor_notifications", ["nurse_task_id"], name: "index_supervisor_notifications_on_nurse_task_id", using: :btree

  create_table "third_contacts", force: :cascade do |t|
    t.integer  "session_length"
    t.integer  "participant_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "notes"
    t.datetime "contact_at"
    t.text     "q1"
    t.boolean  "q2"
    t.text     "q2_notes"
    t.boolean  "q3"
    t.text     "q3_notes"
    t.boolean  "q4"
    t.text     "q4_notes"
    t.boolean  "q5"
    t.text     "q5_notes"
    t.string   "difficulties"
  end

  add_index "third_contacts", ["participant_id"], name: "index_third_contacts_on_participant_id", using: :btree

  create_table "token_auth_authentication_tokens", force: :cascade do |t|
    t.integer "entity_id",                             null: false
    t.string  "value",       limit: 32,                null: false
    t.boolean "is_enabled",             default: true, null: false
    t.string  "uuid",        limit: 36,                null: false
    t.string  "client_uuid",                           null: false
  end

  add_index "token_auth_authentication_tokens", ["client_uuid"], name: "index_token_auth_authentication_tokens_on_client_uuid", unique: true, using: :btree
  add_index "token_auth_authentication_tokens", ["entity_id"], name: "index_token_auth_authentication_tokens_on_entity_id", unique: true, using: :btree
  add_index "token_auth_authentication_tokens", ["value"], name: "index_token_auth_authentication_tokens_on_value", unique: true, using: :btree

  create_table "token_auth_configuration_tokens", force: :cascade do |t|
    t.datetime "expires_at", null: false
    t.string   "value",      null: false
    t.integer  "entity_id",  null: false
  end

  add_index "token_auth_configuration_tokens", ["entity_id"], name: "index_token_auth_configuration_tokens_on_entity_id", unique: true, using: :btree

  create_table "token_auth_synchronizable_resources", force: :cascade do |t|
    t.string   "uuid",                                     null: false
    t.integer  "entity_id",                                null: false
    t.string   "entity_id_attribute_name",                 null: false
    t.string   "name",                                     null: false
    t.string   "class_name",                               null: false
    t.boolean  "is_pullable",              default: false, null: false
    t.boolean  "is_pushable",              default: false, null: false
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                   default: "", null: false
    t.string   "encrypted_password",      default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",           default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "role"
    t.string   "phone",                                null: false
    t.string   "first_name",                           null: false
    t.string   "last_name",                            null: false
    t.string   "locale"
    t.string   "timezone",                             null: false
    t.string   "type"
    t.integer  "nurse_supervisor_id"
    t.string   "family_health_unit_name"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "additional_contacts", "participants"
  add_foreign_key "bit_core_content_modules", "bit_core_tools", name: "fk_content_modules_tools"
  add_foreign_key "bit_core_content_providers", "bit_core_content_modules", name: "fk_content_providers_modules"
  add_foreign_key "bit_core_slides", "bit_core_slideshows", name: "fk_slideshows_slides"
  add_foreign_key "call_to_schedule_final_appointments", "participants"
  add_foreign_key "content_access_events", "lessons"
  add_foreign_key "content_access_events", "participants"
  add_foreign_key "first_appointments", "participants", name: "fk_first_appointments_participants"
  add_foreign_key "first_contacts", "participants", name: "fk_first_contacts_participants"
  add_foreign_key "help_messages", "participants"
  add_foreign_key "help_request_calls", "participants"
  add_foreign_key "lack_of_connectivity_calls", "participants"
  add_foreign_key "lessons", "bit_core_slideshows", name: "fk_lessons_slideshows"
  add_foreign_key "logins", "participants"
  add_foreign_key "non_adherence_calls", "participants"
  add_foreign_key "nurse_tasks", "participants"
  add_foreign_key "participant_start_dates", "participants"
  add_foreign_key "participants", "users", column: "nurse_id", name: "fk_participants_nurses"
  add_foreign_key "scheduled_task_cancellations", "nurse_tasks"
  add_foreign_key "scheduled_task_reschedulings", "nurse_tasks"
  add_foreign_key "second_contacts", "participants", name: "fk_second_contacts_participants"
  add_foreign_key "session_events", "lessons"
  add_foreign_key "session_events", "participants"
  add_foreign_key "smartphones", "participants", name: "fk_smartphones_participants"
  add_foreign_key "supervisor_notifications", "nurse_tasks"
end
