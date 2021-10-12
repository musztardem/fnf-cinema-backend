# frozen_string_literal: true

require 'dry/matcher/result_matcher'

module Cinema
  module Movies
    class CalculateMovieRating
      include Dry::Monads[:result, :do]
      include Dry::Matcher.for(:call, with: Dry::Matcher::ResultMatcher)

      def initialize(ratings_repo: RatingsRepository.new)
        @ratings_repo = ratings_repo
      end

      def call(movie_id:)
        ratings = yield load_movie_ratings(movie_id)
        result = yield calculate_avg_rating(ratings)

        Success(result)
      end

      private

      attr_reader :ratings_repo

      def load_movie_ratings(movie_id)
        ratings = ratings_repo.all_movie_ratings(movie_id: movie_id)
        return Failure(nil) if ratings.size.zero?

        Success(ratings)
      end

      def calculate_avg_rating(ratings)
        Success(BigDecimal(ratings.reduce(:+)) / BigDecimal(ratings.size))
      end
    end
  end
end
