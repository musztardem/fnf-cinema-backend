# frozen_string_literal: true

module CinemaAdmin
  module Prices
    class UpdateContract < Dry::Validation::Contract
      params do
        required(:adult_price).filled(:integer)
        required(:child_price).filled(:integer)
      end

      rule(:adult_price) do
        key.failure('must be greater or equal 0') if value.negative?
      end

      rule(:child_price) do
        key.failure('must be greater or equal 0') if value.negative?
      end
    end
  end
end
