# frozen_string_literal: true

module Cinema
  module Entities
    class MovieDetails < Grape::Entity
      expose :imdb_id
      expose :title
      expose :plot
      expose :released
      expose :imdb_rating
      expose :runtime
      expose :users_rating
    end
  end
end
