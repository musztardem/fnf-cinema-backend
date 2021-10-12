# frozen_string_literal: true

module CinemaAdmin
  module V1
    class Showings < Grape::API
      version 'v1', using: :path
      prefix :admin_api

      before { authorize_admin_access! }

      resource :showings do
        desc '[Admin] Returns a list of all movies showings', entity: CinemaAdmin::Entities::Showing
        get do
          CinemaAdmin::Showings::GetAll.new.call do |result|
            result.success { |showings| present showings, with: CinemaAdmin::Entities::Showing }
            result.failure { status :service_unavailable }
          end
        end
      end

      resource :movies do
        route_param :movie_id do
          resource :showings do
            desc '[Admin] Creates a new showing for the specific movie'
            params do
              requires :projection_date, type: DateTime, allow_blank: false,
                                         desc: 'Date and time of the specific movie projection',
                                         documentation: { example: '2022-03-03 20:15:53' }
            end
            post do
              CinemaAdmin::Showings::Create.new.call(
                movie_id: params[:movie_id],
                projection_date: params[:projection_date]
              ) do |result|
                result.success { status :created }
                result.failure(:not_found) { error!({ message: 'Movie does not exist' }, :not_found) }
                result.failure(Dry::Validation::MessageSet) do |e|
                  error!({ message: 'Validation failed', errors: e.to_h }, 422)
                end
                result.failure { status :service_unavailable }
              end
            end

            route_param :showing_id do
              desc '[Admin] Updates an existing showing for the specific movie'
              params do
                requires :showing_id, type: Integer, desc: 'Coerced movie showing id'
                requires :projection_date, type: DateTime, allow_blank: false,
                                           desc: 'Date and time of the specific showing'
              end
              patch do
                CinemaAdmin::Showings::Update.new.call(
                  showing_id: params[:showing_id],
                  movie_id: params[:movie_id],
                  projection_date: params[:projection_date]
                ) do |result|
                  result.success { status :ok }
                  result.failure(:showing_not_found) { error!({ message: 'Showing does not exist' }, :not_found) }
                  result.failure(:movie_not_found) { error!({ message: 'Movie does not exist' }, :not_found) }
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
end
