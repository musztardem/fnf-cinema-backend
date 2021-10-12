# frozen_string_literal: true

require 'dry/matcher/result_matcher'

module Cinema
  module Movies
    class GetDetails
      include Dry::Monads[:result, :do]
      include Dry::Matcher.for(:call, with: Dry::Matcher::ResultMatcher)

      def initialize(movies_repo: MoviesRepository.new,
                     movie_details_repo: MovieDetailsRepository.new,
                     movie_rating_service: CalculateMovieRating.new)
        @movies_repo = movies_repo
        @movie_details_repo = movie_details_repo
        @movie_rating_service = movie_rating_service
      end

      def call(movie_id:)
        yield verify_movie_existence(movie_id)
        details = yield load_movie_details(movie_id)
        details_with_users_rating = yield extend_details_with_users_rating(movie_id, details)

        Success(details_with_users_rating)
      end

      private

      attr_reader :movies_repo, :movie_details_repo, :movie_rating_service

      def verify_movie_existence(movie_id)
        return Success(nil) if movies_repo.exists?(id: movie_id)

        Failure(:not_found)
      end

      def load_movie_details(movie_id)
        details = movie_details_repo.load(id: movie_id)

        Success(details)
      rescue MovieDetailsRepository::ConnectionError,
             MovieDetailsRepository::DataInconsistencyError
        Failure(nil)
      end

      def extend_details_with_users_rating(movie_id, details)
        movie_rating_service.call(movie_id: movie_id) do |result|
          result.success do |rating|
            Success(MovieDetailsWithUsersRatingValue
              .new(details.attributes.merge(users_rating: rating)))
          end
          result.failure do
            Success(MovieDetailsWithUsersRatingValue
              .new(details.attributes.merge(users_rating: BigDecimal(0))))
          end
        end
      end
    end
  end
end
