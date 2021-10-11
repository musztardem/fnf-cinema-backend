# frozen_string_literal: true

require 'dry/matcher/result_matcher'

module CinemaAdmin
  module Prices
    class Get
      include Dry::Monads[:result, :do]
      include Dry::Matcher.for(:call, with: Dry::Matcher::ResultMatcher)

      def initialize(prices_repo: PricesRepository.new)
        @prices_repo = prices_repo
      end

      def call
        prices = yield load_prices

        Success(prices)
      end

      private

      attr_reader :prices_repo

      def load_prices
        result = prices_repo.get
        return Failure(:not_found) if result.nil?

        Success(result)
      rescue PricesRepository::DataInconsistencyError
        Failure(nil)
      end
    end
  end
end
