# frozen_string_literal: true

module CinemaAdmin
  module Showings
    class UpdateContract < Dry::Validation::Contract
      params do
        required(:showing_id).value(:integer)
        required(:movie_id).value(:string)
        required(:projection_date).value(:date_time)
      end

      rule(:projection_date) do
        key.failure('must be in the future') if value.past?
      end
    end
  end
end
