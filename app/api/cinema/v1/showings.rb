# frozen_string_literal: true

module Cinema
  module V1
    class Showings < Grape::API
      version 'v1', using: :path
      prefix :api

      namespace :movies do
        route_param :movie_id do
          resource :showings do
            desc 'Returns a list of movie showings for the specific movie'
            get do
              status :ok
            end
          end
        end
      end
    end
  end
end
