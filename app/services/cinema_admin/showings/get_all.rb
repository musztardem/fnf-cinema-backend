# frozen_string_literal: true

require 'dry/matcher/result_matcher'

module CinemaAdmin
  module Showings
    class GetAll
      include Dry::Monads[:result, :do]
      include Dry::Matcher.for(:call, with: Dry::Matcher::ResultMatcher)

      def initialize(showings_repo: ShowingsRepository.new)
        @showings_repo = showings_repo
      end

      def call
        showings = yield load_all_showings
        Success(showings)
      end

      private

      attr_reader :showings_repo

      def load_all_showings
        result = showings_repo.all
        Success(result)
      end
    end
  end
end
