# frozen_string_literal: true

module CinemaAdmin
  module Entities
    class Showing < Grape::Entity
      expose :id
      expose :movie_id
      expose :projection_date
    end
  end
end
