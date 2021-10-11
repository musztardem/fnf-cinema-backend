# frozen_string_literal: true

class CreateShowings < ActiveRecord::Migration[6.1]
  def change
    create_table :showings do |t|
      t.datetime :projection_date
      t.string :movie_id, null: false, index: true

      t.timestamps
    end

    add_foreign_key :showings, :movies
  end
end
