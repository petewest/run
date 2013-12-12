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

ActiveRecord::Schema.define(version: 20131212191120) do

  create_table "activity_types", force: true do |t|
    t.string   "name"
    t.string   "identifier"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", force: true do |t|
    t.string   "name"
    t.string   "stub"
    t.integer  "sort_order"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categories", ["stub", "sort_order"], name: "index_categories_on_stub_and_sort_order", unique: true

  create_table "posts", force: true do |t|
    t.string   "title"
    t.text     "write_up"
    t.integer  "user_id"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "posts", ["category_id"], name: "index_posts_on_category_id"
  add_index "posts", ["user_id"], name: "index_posts_on_user_id"

  create_table "sessions", force: true do |t|
    t.string   "ip_addr"
    t.boolean  "permanent"
    t.string   "remember_token"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["remember_token"], name: "index_sessions_on_remember_token", unique: true
  add_index "sessions", ["user_id"], name: "index_sessions_on_user_id"

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "gravatar_email"
    t.boolean  "admin",           default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true

end
