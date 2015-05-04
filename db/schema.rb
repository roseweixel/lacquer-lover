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

ActiveRecord::Schema.define(version: 20150504024524) do

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace",     limit: 255
    t.text     "body"
    t.string   "resource_id",   limit: 255, null: false
    t.string   "resource_type", limit: 255, null: false
    t.integer  "author_id"
    t.string   "author_type",   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"

  create_table "admin_users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true

  create_table "brands", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "colors", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "favorites", force: :cascade do |t|
    t.integer  "lacquer_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "finishes", force: :cascade do |t|
    t.string "description", limit: 255
  end

  create_table "friendships", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "friend_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state",      limit: 255, default: "pending"
  end

  add_index "friendships", ["state"], name: "index_friendships_on_state"
  add_index "friendships", ["user_id", "friend_id"], name: "index_friendships_on_user_id_and_friend_id"

  create_table "gifts", force: :cascade do |t|
    t.integer  "user_lacquer_id"
    t.integer  "requester_id"
    t.integer  "owner_id"
    t.string   "state",           default: "pending"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.datetime "date_completed"
  end

  create_table "lacquer_words", force: :cascade do |t|
    t.integer  "word_id"
    t.integer  "lacquer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lacquers", force: :cascade do |t|
    t.string   "name",             limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "brand_id"
    t.integer  "user_added_by_id"
    t.string   "default_picture",  limit: 255
    t.string   "item_url",         limit: 255
    t.string   "buy_url"
  end

  create_table "logins", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reviews", force: :cascade do |t|
    t.integer  "rating"
    t.text     "comments"
    t.integer  "lacquer_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "swatches", force: :cascade do |t|
    t.integer  "lacquer_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "transactions", force: :cascade do |t|
    t.integer  "user_lacquer_id"
    t.integer  "requester_id"
    t.datetime "date_ended"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state",              limit: 255, default: "pending"
    t.integer  "owner_id"
    t.datetime "due_date"
    t.datetime "date_became_active"
  end

  create_table "user_lacquer_colors", force: :cascade do |t|
    t.integer "user_lacquer_id"
    t.integer "color_id"
  end

  create_table "user_lacquer_finishes", force: :cascade do |t|
    t.integer "user_lacquer_id"
    t.integer "finish_id"
  end

  create_table "user_lacquers", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "lacquer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "loanable",                           default: false
    t.boolean  "on_loan",                            default: false
    t.string   "selected_display_image", limit: 255
    t.boolean  "giftable",                           default: false
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "provider",         limit: 255
    t.string   "uid",              limit: 255
    t.string   "name",             limit: 255
    t.string   "oauth_token",      limit: 255
    t.datetime "oauth_expires_at"
    t.string   "email",            limit: 255
    t.string   "image",            limit: 255
  end

  create_table "words", force: :cascade do |t|
    t.string   "text",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
