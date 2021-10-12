# frozen_string_literal: true

module Cinema
  module Ratings
    class CreateContract < Dry::Validation::Contract
      params do
        required(:user_id).value(:integer)
        required(:movie_id).value(:string)
        required(:rate).value(:integer)
      end

      rule(:rate) do
        key.failure('must be greater than 0') if value.negative?
      end

      rule(:rate) do
        key.failure('must be lesser or equal 5') if value > 5
      end
    end
  end
end
