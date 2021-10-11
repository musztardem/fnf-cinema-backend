# frozen_string_literal: true

module CinemaAdmin
  module V1
    class Prices < Grape::API
      version 'v1', using: :path
      prefix :admin_api

      resources :prices do
        desc 'Returns prices'
        get do
          CinemaAdmin::Prices::Get.new.call do |result|
            result.success { |prices| present prices, with: CinemaAdmin::Entities::Prices }
            result.failure(:not_found) { status :not_found }
            result.failure { status :service_unavailable }
          end
        end

        desc 'Updates prices'
        params do
          requires :adult_price, type: Integer, desc: 'Price for adults'
          requires :child_price, type: Integer, desc: 'Price for children'
        end
        patch do
          CinemaAdmin::Prices::Update.new.call(params.symbolize_keys) do |result|
            result.success { status :ok }
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
