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

ActiveRecord::Schema[7.1].define(version: 2024_01_19_180616) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "articles", force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "course_schedules", force: :cascade do |t|
    t.bigint "users_id"
    t.string "quarter_name"
    t.index ["users_id"], name: "index_course_schedules_on_users_id"
  end

  create_table "enrolled_courses", force: :cascade do |t|
    t.bigint "course_schedules_id"
    t.string "course_name"
    t.string "course_day_of_week"
    t.time "course_meeting_start"
    t.time "course_meeting_end"
    t.index ["course_schedules_id"], name: "index_enrolled_courses_on_course_schedules_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
  end

  add_foreign_key "course_schedules", "users", column: "users_id"
  add_foreign_key "enrolled_courses", "course_schedules", column: "course_schedules_id"
end
