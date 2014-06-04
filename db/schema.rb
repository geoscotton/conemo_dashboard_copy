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

ActiveRecord::Schema.define(version: 20140604162226) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "app_logins", force: true do |t|
    t.datetime "occurred_at"
    t.integer  "participant_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "app_logins", ["participant_id"], name: "index_app_logins_on_participant_id", using: :btree

  create_table "bit_core_content_modules", force: true do |t|
    t.string   "title",                        null: false
    t.integer  "position",         default: 1, null: false
    t.integer  "bit_core_tool_id",             null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bit_core_content_modules", ["bit_core_tool_id", "position"], name: "bit_core_content_module_position", unique: true, using: :btree

  create_table "bit_core_content_providers", force: true do |t|
    t.string   "type",                                   null: false
    t.string   "source_content_type"
    t.integer  "source_content_id"
    t.integer  "bit_core_content_module_id",             null: false
    t.integer  "position",                   default: 1, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bit_core_content_providers", ["bit_core_content_module_id", "position"], name: "bit_core_content_provider_position", unique: true, using: :btree

  create_table "bit_core_slides", force: true do |t|
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

  create_table "bit_core_slideshows", force: true do |t|
    t.string   "title",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bit_core_tools", force: true do |t|
    t.string   "title",                  null: false
    t.integer  "position",   default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bit_core_tools", ["position"], name: "bit_core_tool_position", unique: true, using: :btree

  create_table "content_access_events", force: true do |t|
    t.integer  "participant_id"
    t.datetime "accessed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lesson_id"
    t.integer  "day_in_treatment_accessed"
    t.string   "lesson_datum_guid"
  end

  add_index "content_access_events", ["lesson_id"], name: "index_content_access_events_on_lesson_id", using: :btree
  add_index "content_access_events", ["participant_id"], name: "index_content_access_events_on_participant_id", using: :btree

  create_table "final_appointments", force: true do |t|
    t.datetime "appointment_at"
    t.string   "appointment_location"
    t.boolean  "phone_returned",       null: false
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "participant_id"
  end

  create_table "first_appointments", force: true do |t|
    t.integer  "participant_id",       null: false
    t.datetime "appointment_at",       null: false
    t.string   "appointment_location"
    t.integer  "session_length",       null: false
    t.datetime "next_contact",         null: false
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "first_appointments", ["participant_id"], name: "index_first_appointments_on_participant_id", using: :btree

  create_table "first_contacts", force: true do |t|
    t.integer  "participant_id",             null: false
    t.datetime "contact_at",                 null: false
    t.datetime "first_appointment_at",       null: false
    t.string   "first_appointment_location"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "first_contacts", ["participant_id"], name: "index_first_contacts_on_participant_id", using: :btree

  create_table "help_messages", force: true do |t|
    t.integer  "participant_id"
    t.text     "message"
    t.boolean  "read"
    t.string   "staff_message_guid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "sent_at"
  end

  add_index "help_messages", ["participant_id"], name: "index_help_messages_on_participant_id", using: :btree

  create_table "lessons", force: true do |t|
    t.string   "title",                                null: false
    t.integer  "bit_core_slideshow_id"
    t.integer  "day_in_treatment",      default: 1,    null: false
    t.string   "locale",                default: "en", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "guid",                                 null: false
  end

  add_index "lessons", ["bit_core_slideshow_id"], name: "index_lessons_on_bit_core_slideshow_id", using: :btree

  create_table "logins", force: true do |t|
    t.integer  "participant_id"
    t.datetime "logged_in_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "app_login_guid"
  end

  add_index "logins", ["participant_id"], name: "index_logins_on_participant_id", using: :btree

  create_table "nurse_participant_evaluations", force: true do |t|
    t.integer  "first_appointment_id"
    t.integer  "second_contact_id"
    t.integer  "smartphone_comfort",             null: false
    t.integer  "participant_session_engagement", null: false
    t.integer  "app_usage_prediction",           null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "nurse_participant_evaluations", ["first_appointment_id"], name: "index_nurse_participant_evaluations_on_first_appointment_id", using: :btree
  add_index "nurse_participant_evaluations", ["second_contact_id"], name: "index_nurse_participant_evaluations_on_second_contact_id", using: :btree

  create_table "participants", force: true do |t|
    t.integer  "nurse_id"
    t.string   "first_name",                                  null: false
    t.string   "last_name",                                   null: false
    t.string   "study_identifier",                            null: false
    t.string   "family_health_unit_name",                     null: false
    t.string   "family_record_number",                        null: false
    t.string   "phone",                                       null: false
    t.string   "email"
    t.text     "address"
    t.date     "date_of_birth"
    t.string   "gender"
    t.string   "key_chronic_disorder",                        null: false
    t.date     "enrollment_date",                             null: false
    t.string   "status",                  default: "pending"
    t.string   "emergency_contact_name"
    t.string   "emergency_contact_phone"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "start_date"
    t.string   "locale"
  end

  add_index "participants", ["nurse_id"], name: "index_participants_on_nurse_id", using: :btree

  create_table "patient_contacts", force: true do |t|
    t.string   "contact_reason"
    t.text     "note"
    t.datetime "contact_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "participant_id"
    t.integer  "first_contact_id"
    t.integer  "first_appointment_id"
    t.integer  "second_contact_id"
  end

  add_index "patient_contacts", ["first_appointment_id"], name: "index_patient_contacts_on_first_appointment_id", using: :btree
  add_index "patient_contacts", ["first_contact_id"], name: "index_patient_contacts_on_first_contact_id", using: :btree
  add_index "patient_contacts", ["participant_id"], name: "index_patient_contacts_on_participant_id", using: :btree
  add_index "patient_contacts", ["second_contact_id"], name: "index_patient_contacts_on_second_contact_id", using: :btree

  create_table "reminder_messages", force: true do |t|
    t.integer  "nurse_id",                             null: false
    t.integer  "participant_id",                       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status",           default: "pending"
    t.string   "notify_at"
    t.string   "message_type"
    t.string   "appointment_type"
  end

  add_index "reminder_messages", ["nurse_id"], name: "index_reminder_messages_on_nurse_id", using: :btree
  add_index "reminder_messages", ["participant_id"], name: "index_reminder_messages_on_participant_id", using: :btree

  create_table "responses", force: true do |t|
    t.integer  "content_access_event_id"
    t.string   "question"
    t.string   "name"
    t.string   "answer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "responses", ["content_access_event_id"], name: "index_responses_on_content_access_event_id", using: :btree

  create_table "second_contacts", force: true do |t|
    t.integer  "participant_id",                            null: false
    t.datetime "contact_at",                                null: false
    t.boolean  "video_access",               default: true
    t.integer  "session_length",                            null: false
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "final_appointment_at"
    t.string   "final_appointment_location"
  end

  add_index "second_contacts", ["participant_id"], name: "index_second_contacts_on_participant_id", using: :btree

  create_table "smartphones", force: true do |t|
    t.string   "number",                                  null: false
    t.boolean  "is_app_compatible",       default: false
    t.integer  "participant_id",                          null: false
    t.boolean  "is_owned_by_participant", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_smartphone_owner",     default: false
  end

  add_index "smartphones", ["participant_id"], name: "index_smartphones_on_participant_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "role"
    t.string   "phone",                               null: false
    t.string   "first_name",                          null: false
    t.string   "last_name",                           null: false
    t.string   "locale"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
