# frozen_string_literal: true

module CinemaAdmin
  module Entities
    class Prices < Grape::Entity
      expose :adult_price, documentation: { type: Integer, required: true, desc: 'Price for adult', example: 20 }
      expose :child_price, documentation: { type: Integer, required: true, desc: 'Price for child', example: 15 }
    end
  end
end
