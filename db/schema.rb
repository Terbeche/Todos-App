# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 20_230_408_140_928) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'passwordless_sessions', force: :cascade do |t|
    t.string 'authenticatable_type'
    t.bigint 'authenticatable_id'
    t.datetime 'timeout_at', precision: nil, null: false
    t.datetime 'expires_at', precision: nil, null: false
    t.datetime 'claimed_at', precision: nil
    t.text 'user_agent', null: false
    t.string 'remote_addr', null: false
    t.string 'token', null: false
    t.datetime 'created_at', precision: nil, null: false
    t.datetime 'updated_at', precision: nil, null: false
    t.index %w[authenticatable_type authenticatable_id], name: 'authenticatable'
  end

  create_table 'todos', force: :cascade do |t|
    t.string 'title'
    t.text 'description'
    t.date 'due_date'
    t.boolean 'completed', default: false
    t.integer 'position'
    t.bigint 'user_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['user_id'], name: 'index_todos_on_user_id'
  end

  create_table 'users', force: :cascade do |t|
    t.string 'email', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['email'], name: 'index_users_on_email'
  end

  add_foreign_key 'todos', 'users'
end
