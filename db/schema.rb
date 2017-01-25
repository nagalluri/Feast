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

ActiveRecord::Schema.define(version: 20170117150445) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "groups", force: :cascade do |t|
    t.string   "group_name"
    t.string   "rating_filter"
    t.string   "keyword"
    t.string   "location"
    t.string   "access_token"
    t.integer  "radius"
    t.boolean  "cost_filter1"
    t.boolean  "cost_filter2"
    t.boolean  "cost_filter3"
    t.boolean  "cost_filter4"
    t.string   "users",                      array: true
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["users"], name: "index_groups_on_users", using: :gin
  end

  create_table "users", force: :cascade do |t|
    t.integer  "group_id"
    t.string   "username"
    t.integer  "preferences", default: [],              array: true
    t.string   "restaurants"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

end
