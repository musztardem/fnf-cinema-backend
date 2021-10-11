# frozen_string_literal: true

module CinemaAdmin
  module Entities
    class Prices < Grape::Entity
      expose :adult_price
      expose :child_price
    end
  end
end
