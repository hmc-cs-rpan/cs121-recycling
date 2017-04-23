# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170423045014) do

  create_table "admins", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "articles", force: :cascade do |t|
    t.string   "title"
    t.text     "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "bins", force: :cascade do |t|
    t.string   "name"
    t.integer  "city_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "red"
    t.integer  "green"
    t.integer  "blue"
    t.decimal  "alpha"
    t.index ["city_id"], name: "index_bins_on_city_id"
    t.index ["name", "city_id"], name: "index_bins_on_name_and_city_id", unique: true
  end

  create_table "bins_items", id: false, force: :cascade do |t|
    t.integer "bin_id"
    t.integer "item_id"
    t.index ["bin_id"], name: "index_bins_items_on_bin_id"
    t.index ["item_id"], name: "index_bins_items_on_item_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.string   "image_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_categories_on_name", unique: true
  end

  create_table "cities", force: :cascade do |t|
    t.string   "name"
    t.string   "state"
    t.string   "website_url"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "location_id"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "email"
    t.string   "phone_number"
    t.index ["location_id"], name: "index_cities_on_location_id", unique: true
  end

  create_table "city_officials", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.integer  "city_id"
    t.index ["city_id"], name: "index_city_officials_on_city_id"
    t.index ["email"], name: "index_city_officials_on_email", unique: true
    t.index ["reset_password_token"], name: "index_city_officials_on_reset_password_token", unique: true
  end

  create_table "ckeditor_assets", force: :cascade do |t|
    t.string   "data_file_name",               null: false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.string   "data_fingerprint"
    t.string   "type",              limit: 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.index ["type"], name: "index_ckeditor_assets_on_type"
  end

  create_table "items", force: :cascade do |t|
    t.string   "name"
    t.integer  "category_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "image"
    t.index ["category_id"], name: "index_items_on_category_id"
    t.index ["name"], name: "index_items_on_name", unique: true
  end

  create_table "terms", force: :cascade do |t|
    t.string   "name"
    t.text     "definition"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_terms_on_name", unique: true
  end

  create_table "trigrams", force: :cascade do |t|
    t.string  "trigram",     limit: 3
    t.integer "score",       limit: 2
    t.integer "owner_id"
    t.string  "owner_type"
    t.string  "fuzzy_field"
    t.index ["owner_id", "owner_type", "fuzzy_field", "trigram", "score"], name: "index_for_match"
    t.index ["owner_id", "owner_type"], name: "index_by_owner"
  end

  create_table "zip_codes", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "city_id"
    t.index ["city_id"], name: "index_zip_codes_on_city_id"
    t.index ["name"], name: "index_zip_codes_on_name", unique: true
  end

end
