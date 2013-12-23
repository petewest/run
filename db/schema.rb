# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20131223120824) do

  create_table "activities", force: true do |t|
    t.datetime "start_time"
    t.float    "distance"
    t.integer  "duration"
    t.float    "height_gain"
    t.text     "polyline"
    t.text     "time_series"
    t.text     "elevation_series"
    t.text     "hr_series"
    t.text     "pace_series"
    t.text     "gpx"
    t.integer  "activity_type_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "lat_long_series"
  end

  add_index "activities", ["user_id", "start_time"], name: "index_activities_on_user_id_and_start_time", using: :btree

  create_table "activity_types", force: true do |t|
    t.string   "name"
    t.string   "identifier"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "attachments", force: true do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
  end

  add_index "attachments", ["user_id"], name: "index_attachments_on_user_id", using: :btree

  create_table "categories", force: true do |t|
    t.string   "name"
    t.string   "stub"
    t.integer  "sort_order"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categories", ["stub", "sort_order"], name: "index_categories_on_stub_and_sort_order", unique: true, using: :btree

  create_table "posts", force: true do |t|
    t.string   "title"
    t.text     "write_up"
    t.integer  "user_id"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "draft",             default: false
    t.boolean  "facebook_comments", default: false
  end

  add_index "posts", ["category_id"], name: "index_posts_on_category_id", using: :btree
  add_index "posts", ["user_id"], name: "index_posts_on_user_id", using: :btree

  create_table "sessions", force: true do |t|
    t.string   "ip_addr"
    t.boolean  "permanent"
    t.string   "remember_token"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["remember_token"], name: "index_sessions_on_remember_token", unique: true, using: :btree
  add_index "sessions", ["user_id"], name: "index_sessions_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "gravatar_email"
    t.boolean  "admin",           default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "facebook_id"
    t.string   "google_plus"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

end
