# frozen_string_literal: true

class CreateMovies < ActiveRecord::Migration[6.1]
  def change
    create_table :movies, id: false, primary_key: :id do |t|
      t.string :id, null: false
      t.timestamps
    end

    execute 'ALTER TABLE movies ADD PRIMARY KEY (id);'
  end
end
