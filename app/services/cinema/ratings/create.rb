# frozen_string_literal: true

require 'dry/matcher/result_matcher'

module Cinema
  module Ratings
    class Create
      include Dry::Monads[:result, :do]
      include Dry::Matcher.for(:call, with: Dry::Matcher::ResultMatcher)

      def initialize(ratings_repo: RatingsRepository.new,
                     movies_repo: MoviesRepository.new,
                     contract: CreateContract.new)
        @ratings_repo = ratings_repo
        @movies_repo = movies_repo
        @contract = contract
      end

      def call(user_id:, movie_id:, rate:)
        yield verify_movie_existence(movie_id)
        yield verify_if_user_already_rated_movie(user_id, movie_id)
        yield validate_contract(user_id, movie_id, rate)
        yield rate_movie(user_id, movie_id, rate)

        Success(nil)
      end

      private

      attr_reader :ratings_repo, :movies_repo, :contract

      def verify_movie_existence(movie_id)
        return Success(nil) if movies_repo.exists?(id: movie_id)

        Failure(:not_found)
      end

      def verify_if_user_already_rated_movie(user_id, movie_id)
        return Failure(:already_rated) if ratings_repo.exists?(user_id: user_id, movie_id: movie_id)

        Success(nil)
      end

      def validate_contract(user_id, movie_id, rate)
        errors = contract.call(
          user_id: user_id,
          movie_id: movie_id,
          rate: rate
        ).errors
        return Failure(errors) if errors.any?

        Success(nil)
      end

      def rate_movie(user_id, movie_id, rate)
        ratings_repo.create(user_id: user_id, movie_id: movie_id, rate: rate)

        Success(nil)
      end
    end
  end
end
