# frozen_string_literal: true

module CinemaAdmin
  module V1
    class Prices < Grape::API
      version 'v1', using: :path
      prefix :admin_api

      resources :prices do
        desc 'Returns prices'
        get do
          status :ok
        end

        desc 'Updates prices'
        params do
          requires :adult_price, type: Integer, desc: 'Price for adults'
          requires :child_price, type: Integer, desc: 'Price for children'
        end
        patch do
          status :ok
        end
      end
    end
  end
end
