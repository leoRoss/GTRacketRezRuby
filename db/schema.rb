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

ActiveRecord::Schema.define(version: 20141023014549) do

  create_table "reservations", force: true do |t|
    t.string   "gtid",       limit: 20
    t.string   "gtuser",     limit: 20
    t.string   "name",       limit: 50
    t.string   "phone",      limit: 20
    t.datetime "start"
    t.integer  "duration"
    t.integer  "court"
    t.string   "guest1",     limit: 50
    t.string   "guest2",     limit: 50
    t.string   "guest3",     limit: 50
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
