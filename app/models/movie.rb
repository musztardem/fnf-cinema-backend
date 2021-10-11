# frozen_string_literal: true

class Movie < ApplicationRecord
  has_many :showings, dependent: :destroy
  has_many :ratings, dependent: :destroy
end
