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

ActiveRecord::Schema.define(version: 20141108195304) do

  create_table "reservations", force: true do |t|
    t.string   "name",       limit: 50
    t.string   "phone",      limit: 20
    t.string   "gtid",       limit: 50
    t.datetime "start"
    t.integer  "duration"
    t.integer  "court"
    t.string   "guest1",     limit: 50
    t.string   "guest2",     limit: 50
    t.string   "guest3",     limit: 50
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "reservations", ["user_id"], name: "index_reservations_on_user_id"

  create_table "users", force: true do |t|
    t.string   "email",                             default: "",    null: false
    t.string   "encrypted_password",                default: "",    null: false
    t.string   "name",                   limit: 50, default: "",    null: false
    t.string   "phone",                  limit: 20, default: "",    null: false
    t.boolean  "admin",                             default: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                     default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
