# frozen_string_literal: true

module Cinema
  module V1
    class Ratings < Grape::API
      version 'v1', using: :path
      prefix :api

      before { authorize_standard_user_access! }

      namespace :movies do
        route_param :movie_id do
          resource :ratings do
            desc 'Allows user to rate a movie'
            params do
              requires :rate, type: Integer, desc: 'Rate for the specific movie'
            end
            post do
              Cinema::Ratings::Create.new.call(
                user_id: @current_user_id,
                movie_id: params[:movie_id],
                rate: params[:rate]
              ) do |result|
                result.success { status :created }
                result.failure(:not_found) { error!({ message: 'Movie not found' }, 404) }
                result.failure(:already_rated) { error!({ message: 'Movie already rated' }, 422) }
                result.failure(Dry::Validation::MessageSet) do |e|
                  error!({ message: 'Validation failed', errors: e.to_h }, 422)
                end
                result.failure { status :service_unavailable }
              end
            end
          end
        end
      end
    end
  end
end
