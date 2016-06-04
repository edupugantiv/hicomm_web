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

ActiveRecord::Schema.define(version: 20160516042145) do

  create_table "affiliations", id: false, force: :cascade do |t|
    t.integer "project_id", limit: 4, null: false
    t.integer "group_id",   limit: 4, null: false
  end

  create_table "authentication_codes", force: :cascade do |t|
    t.string   "phone_number",          limit: 255
    t.string   "code",                  limit: 255
    t.string   "clickatell_message_id", limit: 255
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  create_table "cards", force: :cascade do |t|
    t.integer  "subscription_id", limit: 4
    t.string   "name",            limit: 255
    t.string   "card_type",       limit: 255
    t.string   "expiry_month",    limit: 255
    t.string   "expiry_year",     limit: 255
    t.string   "card_number",     limit: 255
    t.string   "cvc",             limit: 255
    t.string   "ip_address",      limit: 255
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "contacts", force: :cascade do |t|
    t.integer "user_id",      limit: 4
    t.integer "colleague_id", limit: 4
  end

  create_table "conversations", force: :cascade do |t|
    t.string  "name",       limit: 255
    t.integer "project_id", limit: 4
    t.string  "code",       limit: 255
    t.string  "slug",       limit: 255
  end

  add_index "conversations", ["slug"], name: "index_conversations_on_slug", unique: true, using: :btree

  create_table "conversers", id: false, force: :cascade do |t|
    t.integer "user_id",         limit: 4, null: false
    t.integer "conversation_id", limit: 4, null: false
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",           limit: 255, null: false
    t.integer  "sluggable_id",   limit: 4,   null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope",          limit: 255
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

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
    t.string   "slug",                limit: 255
  end

  add_index "groups", ["slug"], name: "index_groups_on_slug", unique: true, using: :btree

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

  create_table "notifications", force: :cascade do |t|
    t.string   "subject",    limit: 255
    t.string   "body",       limit: 255
    t.boolean  "is_read",    limit: 1
    t.integer  "user_id",    limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "organizations", force: :cascade do |t|
    t.string "users",  limit: 255
    t.string "groups", limit: 255
  end

  create_table "participants", id: false, force: :cascade do |t|
    t.integer "user_id",    limit: 4, null: false
    t.integer "project_id", limit: 4, null: false
  end

  create_table "paypal_notifications", force: :cascade do |t|
    t.string   "action",          limit: 255
    t.string   "ipn_track_id",    limit: 255
    t.string   "profile_id",      limit: 255
    t.integer  "subscription_id", limit: 4
    t.boolean  "is_read",         limit: 1,   default: false
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
  end

  create_table "posts", force: :cascade do |t|
    t.text     "body",      limit: 65535
    t.datetime "posted"
    t.integer  "poster_id", limit: 4
    t.integer  "group_id",  limit: 4
  end

  create_table "projects", force: :cascade do |t|
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
    t.string   "code",                limit: 255
    t.boolean  "is_active",           limit: 1,   default: false
    t.string   "slug",                limit: 255
  end

  add_index "projects", ["slug"], name: "index_projects_on_slug", unique: true, using: :btree

  create_table "requests", force: :cascade do |t|
    t.integer "user_id",    limit: 4
    t.integer "project_id", limit: 4
    t.integer "group_id",   limit: 4
    t.boolean "pending",    limit: 1
    t.string  "type",       limit: 255
    t.integer "request_by", limit: 4
    t.integer "request_to", limit: 4
  end

  create_table "schedules", force: :cascade do |t|
    t.integer  "subscription_id", limit: 4
    t.datetime "date"
    t.boolean  "is_finished",     limit: 1
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "schedules", ["subscription_id"], name: "index_schedules_on_subscription_id", using: :btree

  create_table "subscriptions", force: :cascade do |t|
    t.string   "plan",                limit: 255
    t.string   "payer_email",         limit: 255
    t.string   "payer_id",            limit: 255
    t.boolean  "is_through_card",     limit: 1
    t.integer  "card_id",             limit: 4
    t.boolean  "is_recurring",        limit: 1,   default: true
    t.string   "transaction_id",      limit: 255
    t.string   "profile_id",          limit: 255
    t.integer  "cycle_count",         limit: 4,   default: 1
    t.string   "payment_status",      limit: 255, default: "active"
    t.boolean  "is_success",          limit: 1
    t.string   "notification_params", limit: 255
    t.float    "total_amount",        limit: 24
    t.float    "total_mc_gross",      limit: 24
    t.float    "total_mc_fee",        limit: 24
    t.float    "total_tax",           limit: 24
    t.float    "amount",              limit: 24
    t.float    "mc_gross",            limit: 24
    t.float    "mc_fee",              limit: 24
    t.float    "tax",                 limit: 24
    t.boolean  "is_active",           limit: 1
    t.integer  "user_id",             limit: 4
    t.integer  "project_id",          limit: 4
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "job",                    limit: 255
    t.string   "location",               limit: 255
    t.string   "mobile",                 limit: 255
    t.string   "email",                  limit: 255
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
    t.string   "country",                limit: 255
    t.string   "type",                   limit: 255
    t.boolean  "is_active",              limit: 1,   default: false
    t.string   "slug",                   limit: 255
  end

  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["slug"], name: "index_users_on_slug", unique: true, using: :btree

  add_foreign_key "schedules", "subscriptions"
end
