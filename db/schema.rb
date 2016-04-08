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

ActiveRecord::Schema.define(version: 20160317093059) do

  create_table "affiliations", id: false, force: :cascade do |t|
    t.integer "project_id", limit: 4, null: false
    t.integer "group_id",   limit: 4, null: false
  end

  create_table "contacts", force: :cascade do |t|
    t.integer "user_id",      limit: 4
    t.integer "colleague_id", limit: 4
  end

  create_table "conversations", force: :cascade do |t|
    t.string  "code",       limit: 255
    t.string  "name",       limit: 255
    t.integer "project_id", limit: 4
  end

  create_table "conversers", id: false, force: :cascade do |t|
    t.integer "user_id",         limit: 4, null: false
    t.integer "conversation_id", limit: 4, null: false
  end

  add_index "conversers", ["user_id", "conversation_id"], name: "index_conversers_on_user_id_and_conversation_id", unique: true, using: :btree

  create_table "groups", force: :cascade do |t|
    t.string   "name",                limit: 255
    t.integer  "group_leader_id",     limit: 4
    t.string   "privacy",             limit: 255
    t.string   "scale",               limit: 255
    t.string   "location",            limit: 255
    t.string   "avatar_file_name",    limit: 255
    t.string   "avatar_content_type", limit: 255
    t.integer  "avatar_file_size",    limit: 4
    t.datetime "avatar_updated_at"
    t.boolean  "is_active",           limit: 1,   default: false
  end

  create_table "members", id: false, force: :cascade do |t|
    t.integer "group_id", limit: 4, null: false
    t.integer "user_id",  limit: 4, null: false
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

  add_index "participants", ["user_id", "project_id"], name: "index_participants_on_user_id_and_project_id", unique: true, using: :btree

  create_table "posts", force: :cascade do |t|
    t.text     "body",      limit: 65535
    t.datetime "posted"
    t.integer  "poster_id", limit: 4
    t.integer  "group_id",  limit: 4
  end

  create_table "projects", force: :cascade do |t|
    t.string   "code",                limit: 255
    t.string   "name",                limit: 255
    t.integer  "project_manager_id",  limit: 4
    t.string   "location",            limit: 255
    t.string   "scale",               limit: 255
    t.string   "privacy",             limit: 255
    t.string   "plan",                limit: 255
    t.string   "avatar_file_name",    limit: 255
    t.string   "avatar_content_type", limit: 255
    t.integer  "avatar_file_size",    limit: 4
    t.datetime "avatar_updated_at"
    t.boolean  "is_active",           limit: 1,   default: false
  end

  create_table "requests", force: :cascade do |t|
    t.integer "user_id",    limit: 4
    t.integer "project_id", limit: 4
    t.integer "group_id",   limit: 4
    t.boolean "pending",    limit: 1
    t.string  "type",       limit: 255
  end

  create_table "users", force: :cascade do |t|
    t.string   "job",                    limit: 255
    t.string   "location",               limit: 255
    t.string   "country",                limit: 255,                 null: false
    t.string   "mobile",                 limit: 255
    t.string   "email",                  limit: 255, default: "",    null: false
    t.string   "encrypted_password",     limit: 255, default: "",    null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "privacy",                limit: 255
    t.string   "first_name",             limit: 255
    t.string   "last_name",              limit: 255
    t.string   "avatar_file_name",       limit: 255
    t.string   "avatar_content_type",    limit: 255
    t.integer  "avatar_file_size",       limit: 4
    t.datetime "avatar_updated_at"
    t.string   "type",                   limit: 255
    t.boolean  "is_active",              limit: 1,   default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
