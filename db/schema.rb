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

ActiveRecord::Schema.define(version: 20141130233536) do

  create_table "brands", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "colors", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "finishes", force: true do |t|
    t.string "description"
  end

  create_table "friendships", force: true do |t|
    t.integer  "user_id"
    t.integer  "friend_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state"
  end

  add_index "friendships", ["state"], name: "index_friendships_on_state"
  add_index "friendships", ["user_id", "friend_id"], name: "index_friendships_on_user_id_and_friend_id"

  create_table "lacquers", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "brand_id"
    t.integer  "user_added_by_id"
  end

  create_table "swatches", force: true do |t|
    t.integer  "lacquer_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "transactions", force: true do |t|
    t.integer  "user_lacquer_id"
    t.integer  "requester_id"
    t.string   "type"
    t.datetime "date_ended"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state"
    t.integer  "owner_id"
    t.datetime "due_date"
    t.datetime "date_became_active"
  end

  create_table "user_lacquer_colors", force: true do |t|
    t.integer "user_lacquer_id"
    t.integer "color_id"
  end

  create_table "user_lacquer_finishes", force: true do |t|
    t.integer "user_lacquer_id"
    t.integer "finish_id"
  end

  create_table "user_lacquers", force: true do |t|
    t.integer  "user_id"
    t.integer  "lacquer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "loanable",   default: false
    t.boolean  "on_loan",    default: false
  end

  create_table "users", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "oauth_token"
    t.datetime "oauth_expires_at"
  end

end
