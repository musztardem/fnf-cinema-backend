# frozen_string_literal: true

class User < ApplicationRecord
  has_many :ratings, dependent: :destroy
  enum role: { moviegoer: 'moviegoer', admin: 'admin' }
end
