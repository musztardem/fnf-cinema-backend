# frozen_string_literal: true

require 'dry/matcher/result_matcher'

module Cinema
  module Showings
    class Get
      include Dry::Monads[:result, :do]
      include Dry::Matcher.for(:call, with: Dry::Matcher::ResultMatcher)

      def initialize(showings_repo: ShowingsRepository.new,
                     movies_repo: MoviesRepository.new)
        @showings_repo = showings_repo
        @movies_repo = movies_repo
      end

      def call(movie_id:)
        yield verify_movie_existence(movie_id)
        showings = yield load_movie_showings(movie_id)

        Success(showings)
      end

      private

      attr_reader :showings_repo, :movies_repo

      def verify_movie_existence(movie_id)
        return Success(nil) if movies_repo.exists?(id: movie_id)

        Failure(:not_found)
      end

      def load_movie_showings(movie_id)
        showings = showings_repo.list_showings_for_movie(movie_id: movie_id)

        Success(showings)
      end
    end
  end
end
