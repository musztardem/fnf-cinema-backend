# frozen_string_literal: true

module CinemaAdmin
  module Showings
    class CreateContract < Dry::Validation::Contract
      params do
        required(:movie_id).value(:string)
        required(:projection_date).value(:date_time)
      end

      rule(:projection_date) do
        key.failure('must be in the future') if value.past?
      end
    end
  end
end
