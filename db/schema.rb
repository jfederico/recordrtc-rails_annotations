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

ActiveRecord::Schema.define(version: 20170626135400) do

  create_table "accounts", force: :cascade do |t|
    t.string   "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "collaboration_callbacks", force: :cascade do |t|
    t.string   "request_method"
    t.string   "host"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "rails_lti2_provider_lti_launches", force: :cascade do |t|
    t.integer  "tool_id",    limit: 8
    t.string   "nonce"
    t.text     "message"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "rails_lti2_provider_registrations", force: :cascade do |t|
    t.string   "uuid"
    t.text     "registration_request_params"
    t.text     "tool_proxy_json"
    t.string   "workflow_state"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.integer  "tool_id",                     limit: 8
    t.text     "correlation_id"
    t.index ["correlation_id"], name: "index_rails_lti2_provider_registrations_on_correlation_id", unique: true
  end

  create_table "rails_lti2_provider_tools", force: :cascade do |t|
    t.string   "uuid"
    t.text     "shared_secret"
    t.text     "tool_settings"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "lti_version"
  end

  create_table "recordings", force: :cascade do |t|
    t.string   "title"
    t.string   "description"
    t.text     "video_data"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "account_id"
    t.index ["account_id"], name: "index_recordings_on_account_id"
  end

end
