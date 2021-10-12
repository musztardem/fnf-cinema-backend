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
            Cinema::Movies::GetDetails.new.call(movie_id: params[:movie_id]) do |result|
              result.success { |details| present details, with: Cinema::Entities::MovieDetails }
              result.failure(:not_found) { error!({ message: 'Movie not found' }, :not_found) }
              result.failure { status :service_unavailable }
            end
          end
        end
      end
    end
  end
end
