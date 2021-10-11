# frozen_string_literal: true

module CinemaAdmin
  module V1
    class Showings < Grape::API
      version 'v1', using: :path
      prefix :admin_api

      resource :showings do
        desc '[Admin] Returns a list of all movies showings'
        get do
          status :ok
        end
      end

      resource :movies do
        route_param :movie_id do
          resource :showings do
            desc '[Admin] Creates a new showing for the specific movie'
            params do
              requires :projection_date, type: Time, allow_blank: false,
                                         desc: 'Date and time of the specific movie projection'
            end
            post do
              status :ok
            end

            route_param :showing_id do
              desc '[Admin] Updates an existing showing for the specific movie'
              params do
                requires :showing_id, type: Integer, desc: 'Coerced movie showing id'
                requires :projection_date, type: DateTime, allow_blank: false,
                                           desc: 'Date and time of the specific showing'
              end
              patch do
                status :ok
              end
            end
          end
        end
      end
    end
  end
end
