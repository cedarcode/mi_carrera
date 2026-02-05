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

ActiveRecord::Schema[8.1].define(version: 2026_01_29_013020) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "unaccent"

  create_table "approvables", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.boolean "is_exam", null: false
    t.integer "subject_id", null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["subject_id"], name: "index_approvables_on_subject_id"
  end

  create_table "degrees", id: :string, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "current_plan", null: false
    t.boolean "include_inco_subjects", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "prerequisites", force: :cascade do |t|
    t.integer "amount_of_subjects_needed"
    t.integer "approvable_id"
    t.integer "approvable_needed_id"
    t.integer "credits_needed"
    t.string "logical_operator"
    t.integer "parent_prerequisite_id"
    t.integer "subject_group_id"
    t.string "type", null: false
    t.index ["approvable_id"], name: "index_prerequisites_on_approvable_id"
    t.index ["parent_prerequisite_id"], name: "index_prerequisites_on_parent_prerequisite_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "credits_to_difficulty_rating"
    t.integer "interesting_rating"
    t.bigint "subject_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["subject_id", "user_id"], name: "index_reviews_on_subject_id_and_user_id", unique: true
  end

  create_table "subject_groups", force: :cascade do |t|
    t.string "code"
    t.datetime "created_at", precision: nil, null: false
    t.integer "credits_needed", default: 0, null: false
    t.string "degree_id", null: false
    t.string "name", null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["degree_id", "code"], name: "index_subject_groups_on_degree_id_and_code", unique: true
    t.index ["degree_id"], name: "index_subject_groups_on_degree_id"
  end

  create_table "subject_plans", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "semester", null: false
    t.bigint "subject_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id", "subject_id"], name: "index_subject_plans_on_user_id_and_subject_id", unique: true
  end

  create_table "subjects", force: :cascade do |t|
    t.string "category", default: "optional"
    t.string "code"
    t.datetime "created_at", precision: nil, null: false
    t.integer "credits", null: false
    t.boolean "current_optional_subject", default: false
    t.string "degree_id", null: false
    t.string "eva_id"
    t.integer "group_id"
    t.string "name", null: false
    t.string "openfing_id"
    t.string "second_semester_eva_id"
    t.string "short_name"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["degree_id", "code"], name: "index_subjects_on_degree_id_and_code", unique: true
    t.index ["degree_id"], name: "index_subjects_on_degree_id"
    t.index ["group_id"], name: "index_subjects_on_group_id"
  end

  create_table "users", force: :cascade do |t|
    t.text "approvals"
    t.datetime "created_at", null: false
    t.string "degree_id", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.integer "failed_attempts", default: 0, null: false
    t.datetime "locked_at"
    t.integer "planned_semesters", default: 10, null: false
    t.boolean "planner_banner_viewed", default: false, null: false
    t.string "provider"
    t.datetime "remember_created_at", precision: nil
    t.datetime "reset_password_sent_at", precision: nil
    t.string "reset_password_token"
    t.string "uid"
    t.string "unlock_token"
    t.datetime "updated_at", null: false
    t.uuid "webauthn_id", default: -> { "gen_random_uuid()" }, null: false
    t.boolean "welcome_banner_viewed", default: false
    t.index ["degree_id"], name: "index_users_on_degree_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  create_table "webauthn_credentials", force: :cascade do |t|
    t.integer "authentication_factor", limit: 2, null: false
    t.datetime "created_at", null: false
    t.string "external_id", null: false
    t.string "name", null: false
    t.text "public_key", null: false
    t.bigint "sign_count", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["external_id"], name: "index_webauthn_credentials_on_external_id", unique: true
    t.index ["user_id"], name: "index_webauthn_credentials_on_user_id"
  end

  add_foreign_key "approvables", "subjects"
  add_foreign_key "prerequisites", "approvables"
  add_foreign_key "prerequisites", "approvables", column: "approvable_needed_id"
  add_foreign_key "prerequisites", "prerequisites", column: "parent_prerequisite_id"
  add_foreign_key "prerequisites", "subject_groups"
  add_foreign_key "reviews", "subjects"
  add_foreign_key "reviews", "users"
  add_foreign_key "subject_groups", "degrees"
  add_foreign_key "subject_plans", "subjects"
  add_foreign_key "subject_plans", "users"
  add_foreign_key "subjects", "degrees"
  add_foreign_key "subjects", "subject_groups", column: "group_id"
  add_foreign_key "users", "degrees"
  add_foreign_key "webauthn_credentials", "users"
end
