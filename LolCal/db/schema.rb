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

ActiveRecord::Schema[7.1].define(version: 2024_03_03_201505) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "builds", force: :cascade do |t|
    t.string "name"
    t.bigint "user_id"
    t.index ["user_id"], name: "index_builds_on_user_id"
  end

  create_table "build_items", force: :cascade do |t|
    t.bigint "build_id"
    t.bigint "item_id"
    t.index ["build_id"], name: "index_build_items_on_build_id"
    t.index ["item_id"], name: "index_build_items_on_item_id"
  end

  create_table "items", force: :cascade do |t|
    t.text "name"
    t.text "description"
    t.text "colloq"
    t.text "plaintext"
    t.boolean "consumed"
    t.integer "stacks"
    t.integer "depth"
    t.boolean "consume_on_full"
    t.text "from_array", default: [], array: true
    t.text "into_array", default: [], array: true
    t.integer "special_recipe"
    t.boolean "in_store"
    t.boolean "hide_from_all"
    t.text "required_champion"
    t.text "required_ally"
    t.jsonb "stats"
    t.text "tags", default: [], array: true
    t.jsonb "maps"
    t.jsonb "gold"
    t.jsonb "image"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "builds", "users", column: "user_id", on_delete: :cascade
  add_foreign_key "build_items", "builds", column: "build_id", on_delete: :cascade
  add_foreign_key "build_items", "items", column: "item_id"
end
