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

ActiveRecord::Schema.define(version: 2020_03_14_210832) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "integreat_apps", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "webhook_url"
    t.string "webhook_secret"
    t.string "secret"
    t.text "webhook_events", default: [], array: true
    t.text "api_scopes", default: [], array: true
    t.string "entry_url"
    t.integer "state", default: 0
    t.integer "availability", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["secret"], name: "index_integreat_apps_on_secret", unique: true
  end

  create_table "integreat_installations", force: :cascade do |t|
    t.integer "account_id"
    t.string "account_type"
    t.integer "app_id"
    t.string "secret"
    t.text "authorized_webhook_events", default: [], array: true
    t.text "authorized_api_scopes", default: [], array: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["secret"], name: "index_integreat_installations_on_secret", unique: true
  end

end
