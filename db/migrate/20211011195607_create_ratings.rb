# frozen_string_literal: true

class CreateRatings < ActiveRecord::Migration[6.1]
  def change
    create_table :ratings do |t|
      t.integer :rate
      t.references :user, null: false, foreign_key: true
      t.string :movie_id, null: false, index: true

      t.timestamps
    end

    add_foreign_key :ratings, :movies
  end
end
