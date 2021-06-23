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

ActiveRecord::Schema.define(version: 2021_06_21_152054) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "amount_of_works", force: :cascade do |t|
    t.decimal "tiny"
    t.decimal "little"
    t.decimal "fair"
    t.decimal "large"
    t.decimal "huge"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "complexities", force: :cascade do |t|
    t.decimal "none"
    t.decimal "little"
    t.decimal "fair"
    t.decimal "complex"
    t.decimal "very_complex"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "games", force: :cascade do |t|
    t.string "name"
    t.bigint "amount_of_work_id", null: false
    t.bigint "complexity_id", null: false
    t.bigint "unknown_risk_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["amount_of_work_id"], name: "index_games_on_amount_of_work_id"
    t.index ["complexity_id"], name: "index_games_on_complexity_id"
    t.index ["unknown_risk_id"], name: "index_games_on_unknown_risk_id"
  end

  create_table "unknown_risks", force: :cascade do |t|
    t.decimal "none"
    t.decimal "low"
    t.decimal "some"
    t.decimal "many"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "games", "amount_of_works"
  add_foreign_key "games", "complexities"
  add_foreign_key "games", "unknown_risks"
end
