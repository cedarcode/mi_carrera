# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_05_29_021702) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "unaccent"

  create_table "approvables", force: :cascade do |t|
    t.integer "subject_id", null: false
    t.boolean "is_exam", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "prerequisites", force: :cascade do |t|
    t.string "type", null: false
    t.integer "parent_prerequisite_id"
    t.integer "approvable_id"
    t.string "logical_operator"
    t.integer "credits_needed"
    t.integer "subject_group_id"
    t.integer "approvable_needed_id"
    t.integer "amount_of_subjects_needed"
  end

  create_table "reviews", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "subject_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "recommended"
    t.integer "interesting"
    t.integer "credits_to_difficulty_ratio"
    t.index ["subject_id", "user_id"], name: "index_reviews_on_subject_id_and_user_id", unique: true
  end

  create_table "subject_groups", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "code"
    t.integer "credits_needed", default: 0, null: false
    t.index ["code"], name: "index_subject_groups_on_code", unique: true
  end

  create_table "subject_plans", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "subject_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "semester", null: false
    t.index ["user_id", "subject_id"], name: "index_subject_plans_on_user_id_and_subject_id", unique: true
  end

  create_table "subjects", force: :cascade do |t|
    t.string "name", null: false
    t.integer "credits", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "short_name"
    t.integer "group_id"
    t.string "openfing_id"
    t.string "eva_id"
    t.string "code"
    t.string "category", default: "optional"
    t.boolean "current_optional_subject", default: false
    t.string "second_semester_eva_id"
    t.index ["code"], name: "index_subjects_on_code", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "uid"
    t.string "provider"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "approvals"
    t.boolean "welcome_banner_viewed", default: false
    t.integer "failed_attempts", default: 0, null: false
    t.datetime "locked_at"
    t.string "unlock_token"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  add_foreign_key "reviews", "subjects"
  add_foreign_key "reviews", "users"
  add_foreign_key "subject_plans", "subjects"
  add_foreign_key "subject_plans", "users"
end
