# frozen_string_literal: true

module Cinema
  module V1
    class Users < Grape::API
      version 'v1', using: :path
      prefix :api

      resource :users do
        desc 'Creates a normal user'
        params do
          requires :username, type: String, allow_blank: false
        end
        post do
          status :ok
        end
      end
    end
  end
end
