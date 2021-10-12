# frozen_string_literal: true

require 'dry/matcher/result_matcher'

module CinemaAdmin
  module Showings
    class Create
      include Dry::Monads[:result, :do]
      include Dry::Matcher.for(:call, with: Dry::Matcher::ResultMatcher)

      def initialize(movies_repo: MoviesRepository.new, showings_repo: ShowingsRepository.new,
                     contract: CreateContract.new)
        @movies_repo = movies_repo
        @showings_repo = showings_repo
        @contract = contract
      end

      def call(movie_id:, projection_date:)
        yield verify_movie_existence(movie_id)
        yield validate_contract(movie_id: movie_id, projection_date: projection_date)
        yield create_showing(movie_id: movie_id, projection_date: projection_date)

        Success(nil)
      end

      private

      attr_reader :movies_repo, :showings_repo, :contract

      def verify_movie_existence(movie_id)
        return Success(nil) if movies_repo.exists?(id: movie_id)

        Failure(:not_found)
      end

      def validate_contract(movie_id:, projection_date:)
        errors = contract.call(
          movie_id: movie_id,
          projection_date: projection_date
        ).errors
        return Failure(errors) if errors.any?

        Success(nil)
      end

      def create_showing(movie_id:, projection_date:)
        showings_repo.create(movie_id: movie_id, projection_date: projection_date)

        Success(nil)
      end
    end
  end
end
