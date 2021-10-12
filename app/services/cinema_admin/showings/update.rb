# frozen_string_literal: true

require 'dry/matcher/result_matcher'

module CinemaAdmin
  module Showings
    class Update
      include Dry::Monads[:result, :do]
      include Dry::Matcher.for(:call, with: Dry::Matcher::ResultMatcher)

      def initialize(movies_repo: MoviesRepository.new, showings_repo: ShowingsRepository.new,
                     contract: UpdateContract.new)
        @movies_repo = movies_repo
        @showings_repo = showings_repo
        @contract = contract
      end

      def call(showing_id:, movie_id:, projection_date:)
        yield verify_movie_existence(movie_id)
        yield verify_showing_existence(movie_id: movie_id, showing_id: showing_id)
        yield validate_contract(showing_id: showing_id, movie_id: movie_id,
                                projection_date: projection_date)
        yield update_showing(showing_id: showing_id, projection_date: projection_date)

        Success(nil)
      end

      private

      attr_reader :movies_repo, :showings_repo, :contract

      def verify_movie_existence(movie_id)
        return Success(nil) if movies_repo.exists?(id: movie_id)

        Failure(:movie_not_found)
      end

      def verify_showing_existence(movie_id:, showing_id:)
        return Success(nil) if showings_repo.showing_for_movie?(id: showing_id, movie_id: movie_id)

        Failure(:showing_not_found)
      end

      def validate_contract(showing_id:, movie_id:, projection_date:)
        errors = contract.call(
          showing_id: showing_id,
          movie_id: movie_id,
          projection_date: projection_date
        ).errors
        return Failure(errors) if errors.any?

        Success(nil)
      end

      def update_showing(showing_id:, projection_date:)
        showings_repo.update(id: showing_id, projection_date: projection_date)

        Success(nil)
      end
    end
  end
end
