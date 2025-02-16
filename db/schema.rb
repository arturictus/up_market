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

ActiveRecord::Schema[8.0].define(version: 2025_02_16_164233) do
  create_table "basic_auths", force: :cascade do |t|
    t.string "username"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "business_entities", force: :cascade do |t|
    t.string "name", null: false
    t.integer "share_supply", null: false
    t.integer "sold_supply", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_business_entities_on_name", unique: true
  end

  create_table "buyers", force: :cascade do |t|
    t.string "name"
    t.integer "basic_auth_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["basic_auth_id"], name: "index_buyers_on_basic_auth_id"
  end

  add_foreign_key "buyers", "basic_auths"
end
