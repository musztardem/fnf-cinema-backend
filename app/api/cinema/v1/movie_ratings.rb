# frozen_string_literal: true

module Cinema
  module V1
    class MovieRatings < Grape::API
      version 'v1', using: :path
      prefix :api

      namespace :movies do
        route_param :movie_id do
          resource :movie_ratings do
            desc 'Allows user to rate a movie'
            params do
              requires :rate, type: Integer, desc: 'Rate for the specific movie'
            end
            post do
              status :ok
            end
          end
        end
      end
    end
  end
end
