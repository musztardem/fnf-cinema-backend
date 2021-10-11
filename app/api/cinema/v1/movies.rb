# frozen_string_literal: true

module Cinema
  module V1
    class Movies < Grape::API
      version 'v1', using: :path
      prefix :api

      resource :movies do
        route_param :movie_id do
          desc 'Returns information about specific movie'
          get do
            status :ok
          end
        end
      end
    end
  end
end
