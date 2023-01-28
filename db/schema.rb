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

ActiveRecord::Schema[7.0].define(version: 2023_01_24_180817) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "appliance_features", force: :cascade do |t|
    t.bigint "appliance_id", null: false
    t.string "name", null: false
    t.text "description", null: false
    t.integer "quantity"
    t.decimal "unit_price", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "variety"
    t.index ["appliance_id"], name: "index_appliance_features_on_appliance_id"
  end

  create_table "appliances", force: :cascade do |t|
    t.bigint "property_id", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_appliances_on_name"
    t.index ["property_id"], name: "index_appliances_on_property_id"
  end

  create_table "features", force: :cascade do |t|
    t.bigint "space_id", null: false
    t.string "name", null: false
    t.text "description", null: false
    t.integer "quantity"
    t.decimal "unit_price", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "variety"
    t.index ["space_id"], name: "index_features_on_space_id"
  end

  create_table "groups", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "properties", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "group_id", null: false
    t.string "address"
    t.string "addresstwo"
    t.string "city"
    t.string "state"
    t.string "country"
    t.integer "yearbuilt"
    t.integer "squarefootage"
    t.string "lotsize"
    t.integer "zip"
    t.string "style"
    t.string "letter"
    t.integer "low"
    t.integer "high"
    t.index ["group_id"], name: "index_properties_on_group_id"
  end

  create_table "spaces", force: :cascade do |t|
    t.bigint "property_id", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "location", default: 0, null: false
    t.index ["name"], name: "index_spaces_on_name"
    t.index ["property_id"], name: "index_spaces_on_property_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "group_id", null: false
    t.string "uid"
    t.string "avatar_url"
    t.string "provider"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["group_id"], name: "index_users_on_group_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "appliance_features", "appliances"
  add_foreign_key "appliances", "properties"
  add_foreign_key "features", "spaces"
  add_foreign_key "properties", "groups"
  add_foreign_key "spaces", "properties"
  add_foreign_key "users", "groups"
end
