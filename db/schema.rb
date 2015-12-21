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

ActiveRecord::Schema.define(version: 20151221085703) do

  create_table "detect_faces", force: :cascade do |t|
    t.integer  "photo_id"
    t.integer  "user_id"
    t.float    "width"
    t.float    "height"
    t.float    "face_center_x"
    t.float    "face_center_y"
    t.boolean  "is_recognized"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "detect_faces", ["photo_id"], name: "index_detect_faces_on_photo_id"
  add_index "detect_faces", ["user_id"], name: "index_detect_faces_on_user_id"

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

  create_table "notes", force: :cascade do |t|
    t.integer  "group_id"
    t.integer  "created_user_id"
    t.string   "title"
    t.integer  "user_number_sum"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "notes", ["created_user_id"], name: "index_notes_on_created_user_id"
  add_index "notes", ["group_id"], name: "index_notes_on_group_id"

  create_table "photo_comments", force: :cascade do |t|
    t.integer  "photo_id"
    t.integer  "user_id"
    t.text     "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "photo_comments", ["photo_id", "user_id"], name: "index_photo_comments_on_photo_id_and_user_id", unique: true
  add_index "photo_comments", ["photo_id"], name: "index_photo_comments_on_photo_id"
  add_index "photo_comments", ["user_id"], name: "index_photo_comments_on_user_id"

  create_table "photos", force: :cascade do |t|
    t.integer  "note_id"
    t.integer  "created_user_id"
    t.integer  "user_number_sum"
    t.text     "url"
    t.integer  "width"
    t.integer  "height"
    t.boolean  "is_detected"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "photos", ["created_user_id"], name: "index_photos_on_created_user_id"
  add_index "photos", ["note_id"], name: "index_photos_on_note_id"

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
