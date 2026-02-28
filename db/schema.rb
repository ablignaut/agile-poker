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

ActiveRecord::Schema[8.1].define(version: 2026_02_28_155551) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "amount_of_works", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.decimal "fair"
    t.decimal "huge"
    t.decimal "large"
    t.decimal "little"
    t.decimal "tiny"
    t.datetime "updated_at", null: false
  end

  create_table "complexities", force: :cascade do |t|
    t.decimal "complex"
    t.datetime "created_at", null: false
    t.decimal "fair"
    t.decimal "little"
    t.decimal "none"
    t.datetime "updated_at", null: false
    t.decimal "very_complex"
  end

  create_table "games", force: :cascade do |t|
    t.bigint "amount_of_work_id", null: false
    t.bigint "complexity_id", null: false
    t.datetime "created_at", null: false
    t.string "name"
    t.bigint "unknown_risk_id", null: false
    t.datetime "updated_at", null: false
    t.index ["amount_of_work_id"], name: "index_games_on_amount_of_work_id"
    t.index ["complexity_id"], name: "index_games_on_complexity_id"
    t.index ["unknown_risk_id"], name: "index_games_on_unknown_risk_id"
  end

  create_table "games_players", force: :cascade do |t|
    t.decimal "amount_of_work"
    t.decimal "complexity"
    t.datetime "created_at", null: false
    t.bigint "game_id", null: false
    t.string "name"
    t.decimal "unknown_risk"
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_games_players_on_game_id"
  end

  create_table "stories", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.decimal "estimate"
    t.bigint "game_id", null: false
    t.integer "position", default: 0, null: false
    t.string "status", default: "pending", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.string "url"
    t.index ["game_id", "position"], name: "index_stories_on_game_id_and_position"
    t.index ["game_id", "status"], name: "index_stories_on_game_id_and_status"
    t.index ["game_id"], name: "index_stories_on_game_id"
  end

  create_table "unknown_risks", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.decimal "low"
    t.decimal "many"
    t.decimal "none"
    t.decimal "some"
    t.datetime "updated_at", null: false
  end

  add_foreign_key "games", "amount_of_works"
  add_foreign_key "games", "complexities"
  add_foreign_key "games", "unknown_risks"
  add_foreign_key "games_players", "games"
  add_foreign_key "stories", "games"
end
