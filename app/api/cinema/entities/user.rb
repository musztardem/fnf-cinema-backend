# frozen_string_literal: true

module Cinema
  module Entities
    class User < Grape::Entity
      expose :id, documentation: { type: String, required: true, desc: 'ID of the created user', example: 132 }
    end
  end
end
