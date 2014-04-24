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

ActiveRecord::Schema.define(version: 20140424194431) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "first_appointments", force: true do |t|
    t.integer  "participant_id",       null: false
    t.datetime "appointment_at",       null: false
    t.string   "appointment_location", null: false
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
    t.string   "first_appointment_location", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "first_contacts", ["participant_id"], name: "index_first_contacts_on_participant_id", using: :btree

  create_table "participants", force: true do |t|
    t.integer  "nurse_id_id"
    t.string   "first_name",                          null: false
    t.string   "last_name",                           null: false
    t.string   "study_identifier",                    null: false
    t.string   "family_health_unit_name",             null: false
    t.string   "family_record_number",                null: false
    t.string   "phone",                               null: false
    t.string   "secondary_phone"
    t.string   "email"
    t.text     "address"
    t.date     "date_of_birth"
    t.integer  "gender"
    t.integer  "key_chronic_disorder",                null: false
    t.date     "enrollment_date",                     null: false
    t.integer  "status",                  default: 0
    t.string   "emergency_contact_name"
    t.string   "emergency_contact_phone"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "participants", ["nurse_id_id"], name: "index_participants_on_nurse_id_id", using: :btree

  create_table "smartphones", force: true do |t|
    t.string   "number",                                  null: false
    t.boolean  "is_app_compatible",       default: false
    t.integer  "participant_id",                          null: false
    t.boolean  "is_owned_by_participant", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
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
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
