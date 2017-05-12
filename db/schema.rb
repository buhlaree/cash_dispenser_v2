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

ActiveRecord::Schema.define(version: 20_170_505_222_601) do
  create_table 'accounts', force: :cascade do |t|
    t.integer  'total'
    t.integer  'user_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index %w[user_id created_at], name: 'index_accounts_on_user_id_and_created_at'
    t.index ['user_id'], name: 'index_accounts_on_user_id'
  end

  create_table 'transactions', force: :cascade do |t|
    t.text     'amount'
    t.integer  'account_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.boolean  'deposit'
    t.index %w[account_id created_at], name: 'index_transactions_on_account_id_and_created_at'
    t.index ['account_id'], name: 'index_transactions_on_account_id'
  end

  create_table 'users', force: :cascade do |t|
    t.string   'name'
    t.string   'email'
    t.datetime 'created_at',                      null: false
    t.datetime 'updated_at',                      null: false
    t.string   'password_digest'
    t.boolean  'admin', default: false
    t.index ['email'], name: 'index_users_on_email', unique: true
  end
end
