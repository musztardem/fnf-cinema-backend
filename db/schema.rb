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

ActiveRecord::Schema.define(version: 20_211_011_195_643) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'movies', id: :string, force: :cascade do |t|
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'ratings', force: :cascade do |t|
    t.integer 'rate'
    t.bigint 'user_id', null: false
    t.string 'movie_id', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['movie_id'], name: 'index_ratings_on_movie_id'
    t.index ['user_id'], name: 'index_ratings_on_user_id'
  end

  create_table 'showings', force: :cascade do |t|
    t.datetime 'projection_date'
    t.string 'movie_id', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['movie_id'], name: 'index_showings_on_movie_id'
  end

  create_table 'users', force: :cascade do |t|
    t.string 'username'
    t.string 'role'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  add_foreign_key 'ratings', 'movies'
  add_foreign_key 'ratings', 'users'
  add_foreign_key 'showings', 'movies'
end
