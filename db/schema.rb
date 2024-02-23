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

ActiveRecord::Schema[7.1].define(version: 2024_02_23_105706) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "interactions", force: :cascade do |t|
    t.string "description"
    t.integer "number"
  end

  create_table "substances", force: :cascade do |t|
    t.string "names", default: [], array: true
    t.text "information"
  end

  create_table "substances_interactions", force: :cascade do |t|
    t.bigint "substance1_id"
    t.bigint "substance2_id"
    t.bigint "interaction_id"
    t.string "color"
    t.string "substance1_type"
    t.string "substance2_type"
    t.string "description"
    t.integer "weight"
    t.string "source"
    t.bigint "rating", default: 0
    t.index ["interaction_id"], name: "index_substances_interactions_on_interaction_id"
    t.index ["substance1_id"], name: "index_substances_interactions_on_substance1_id"
    t.index ["substance2_id"], name: "index_substances_interactions_on_substance2_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "uuid"
    t.bigint "chat_id"
    t.bigint "requests_count", default: 0
  end

end
