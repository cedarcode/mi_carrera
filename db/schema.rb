# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_01_28_144851) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "approvables", force: :cascade do |t|
    t.integer "subject_id", null: false
    t.boolean "is_exam", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "prerequisites", force: :cascade do |t|
    t.string "type", null: false
    t.integer "parent_prerequisite_id"
    t.integer "approvable_id"
    t.string "logical_operator"
    t.integer "credits_needed"
    t.integer "subject_group_id"
    t.integer "approvable_needed_id"
  end

  create_table "subject_groups", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "code"
    t.index ["code"], name: "index_subject_groups_on_code", unique: true
  end

  create_table "subjects", force: :cascade do |t|
    t.string "name", null: false
    t.integer "credits", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "short_name"
    t.integer "semester"
    t.integer "group_id", null: false
    t.string "code"
    t.string "openfing_id"
    t.string "eva_id"
    t.index ["code"], name: "index_subjects_on_code", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email_address"
    t.string "avatar_url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "approvals"
    t.string "password_digest"
    t.string "password_reset_token"
  end

end
