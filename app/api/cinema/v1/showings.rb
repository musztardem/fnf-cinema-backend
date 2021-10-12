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
              Cinema::Showings::Get.new.call(movie_id: params[:movie_id]) do |result|
                result.success { |showings| present showings, with: Cinema::Entities::Showing }
                result.failure(:not_found) { error!({ message: 'Movie does not exist' }, :not_found) }
                result.failure { status :service_unavailable }
              end
            end
          end
        end
      end
    end
  end
end
