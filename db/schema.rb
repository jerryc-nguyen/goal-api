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

ActiveRecord::Schema.define(version: 20160730142841) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.integer  "trackable_id"
    t.string   "trackable_type"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "key"
    t.json     "parameters",     default: {}
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activities", ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type", using: :btree
  add_index "activities", ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type", using: :btree

  create_table "chats", force: :cascade do |t|
    t.integer  "sender_id"
    t.integer  "receiver_id"
    t.string   "message",     default: ""
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.datetime "deleted_at"
  end

  add_index "chats", ["receiver_id"], name: "index_chats_on_receiver_id", using: :btree
  add_index "chats", ["sender_id"], name: "index_chats_on_sender_id", using: :btree

  create_table "comments", force: :cascade do |t|
    t.integer  "creator_id"
    t.string   "content",          default: ""
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.datetime "deleted_at"
  end

  add_index "comments", ["commentable_id", "commentable_type"], name: "index_comments_on_commentable_id_and_commentable_type", using: :btree
  add_index "comments", ["creator_id"], name: "index_comments_on_creator_id", using: :btree

  create_table "friendships", force: :cascade do |t|
    t.integer  "friendable_id"
    t.integer  "friend_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.datetime "deleted_at"
  end

  add_index "friendships", ["friendable_id", "friend_id"], name: "index_friendships_on_friendable_id_and_friend_id", unique: true, using: :btree

  create_table "goal_sessions", force: :cascade do |t|
    t.integer  "creator_id"
    t.integer  "participant_id"
    t.integer  "goal_id"
    t.integer  "score"
    t.integer  "likes_count"
    t.integer  "comments_count"
    t.integer  "views_count"
    t.integer  "status",         default: 0
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.datetime "deleted_at"
  end

  add_index "goal_sessions", ["creator_id"], name: "index_goal_sessions_on_creator_id", using: :btree
  add_index "goal_sessions", ["goal_id"], name: "index_goal_sessions_on_goal_id", using: :btree
  add_index "goal_sessions", ["participant_id"], name: "index_goal_sessions_on_participant_id", using: :btree

  create_table "goals", force: :cascade do |t|
    t.string   "name",         default: ""
    t.datetime "start_at"
    t.integer  "repeat_every"
    t.integer  "duration"
    t.string   "sound_name"
    t.boolean  "is_challenge", default: false
    t.boolean  "is_default",   default: false
    t.integer  "status",       default: 0
    t.integer  "creator_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.datetime "deleted_at"
  end

  add_index "goals", ["creator_id"], name: "index_goals_on_creator_id", using: :btree

  create_table "likes", force: :cascade do |t|
    t.integer  "creator_id"
    t.integer  "likeable_id"
    t.string   "likeable_type"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.datetime "deleted_at"
  end

  add_index "likes", ["creator_id"], name: "index_likes_on_creator_id", using: :btree
  add_index "likes", ["likeable_id", "likeable_type"], name: "index_likes_on_likeable_id_and_likeable_type", using: :btree

  create_table "notifications", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "notificable_type"
    t.integer  "notficable_id"
    t.string   "message",          default: ""
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.datetime "deleted_at"
  end

  add_index "notifications", ["notficable_id", "notificable_type"], name: "index_notifications_on_notficable_id_and_notificable_type", using: :btree
  add_index "notifications", ["user_id"], name: "index_notifications_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "display_name",   default: ""
    t.string   "email",          default: ""
    t.string   "avatar_url",     default: ""
    t.string   "facebook_token", default: ""
    t.string   "first_name",     default: ""
    t.string   "last_name",      default: ""
    t.datetime "birthday"
    t.string   "phone_number"
    t.string   "latitude",       default: ""
    t.string   "longitude",      default: ""
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.datetime "deleted_at"
  end

end
