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

ActiveRecord::Schema.define(version: 20150709081121) do

  create_table "conversations", force: :cascade do |t|
    t.string  "name",       limit: 255
    t.integer "project_id", limit: 4
  end

  create_table "conversers", id: false, force: :cascade do |t|
    t.integer "user_id",         limit: 4, null: false
    t.integer "conversation_id", limit: 4, null: false
  end

  create_table "groups", force: :cascade do |t|
    t.integer "user_id",   limit: 4
    t.string  "name",      limit: 255
    t.float   "latitude",  limit: 24
    t.float   "longitude", limit: 24
  end

  create_table "messages", force: :cascade do |t|
    t.text     "body",            limit: 65535
    t.datetime "sent"
    t.integer  "sender_id",       limit: 4
    t.integer  "conversation_id", limit: 4
  end

  create_table "organizations", force: :cascade do |t|
    t.string "users",  limit: 255
    t.string "groups", limit: 255
  end

  create_table "participants", id: false, force: :cascade do |t|
    t.integer "user_id",    limit: 4, null: false
    t.integer "project_id", limit: 4, null: false
  end

  create_table "projects", force: :cascade do |t|
    t.string  "name",               limit: 255
    t.integer "project_manager_id", limit: 4
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",                   limit: 255
    t.string   "job",                    limit: 255
    t.string   "location",               limit: 255
    t.string   "mobile",                 limit: 255
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
