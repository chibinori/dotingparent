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

ActiveRecord::Schema.define(version: 20151221025003) do

  create_table "group_users", force: :cascade do |t|
    t.integer  "group_id"
    t.integer  "user_id"
    t.integer  "user_number"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "family_relation"
    t.boolean  "is_center_displayed"
  end

  add_index "group_users", ["group_id", "user_id"], name: "index_group_users_on_group_id_and_user_id", unique: true
  add_index "group_users", ["group_id"], name: "index_group_users_on_group_id"
  add_index "group_users", ["user_id"], name: "index_group_users_on_user_id"

  create_table "groups", force: :cascade do |t|
    t.string   "name"
    t.integer  "current_user_number"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "login_user_id"
    t.string   "password_digest"
    t.string   "gender"
    t.string   "nickname"
    t.boolean  "is_admin"
    t.boolean  "possibe_login"
    t.text     "image_url"
    t.integer  "image_width"
    t.integer  "image_height"
    t.float    "image_face_width"
    t.float    "image_face_height"
    t.float    "image_face_center_x"
    t.float    "image_face_center_y"
    t.boolean  "image_trained"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.date     "birthday"
    t.integer  "owner_user_id"
    t.string   "face_detect_user_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["login_user_id"], name: "index_users_on_login_user_id", unique: true

end
