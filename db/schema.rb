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

ActiveRecord::Schema.define(version: 20140606205943) do

  create_table "assignments", force: true do |t|
    t.text     "title"
    t.text     "body"
    t.datetime "deadline"
    t.float    "max_grade"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "graded"
  end

  create_table "homework_documents", force: true do |t|
    t.integer  "grader_id"
    t.integer  "submitter_id"
    t.integer  "assignment_id"
    t.text     "content"
    t.float    "grade"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "penalty"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "hashed_token"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["hashed_token"], name: "index_users_on_hashed_token"

end
