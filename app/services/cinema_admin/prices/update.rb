# frozen_string_literal: true

require 'dry/matcher/result_matcher'

module CinemaAdmin
  module Prices
    class Update
      include Dry::Monads[:result, :do]
      include Dry::Matcher.for(:call, with: Dry::Matcher::ResultMatcher)

      def initialize(prices_repo: PricesRepository.new, contract: UpdateContract.new)
        @prices_repo = prices_repo
        @contract = contract
      end

      def call(price_params)
        yield validate_contract(price_params)
        yield update_prices(price_params)

        Success(nil)
      end

      private

      attr_reader :prices_repo, :contract

      def validate_contract(price_params)
        errors = contract.call(
          adult_price: price_params[:adult_price],
          child_price: price_params[:child_price]
        ).errors
        return Failure(errors) if errors.any?

        Success(nil)
      end

      def update_prices(price_params)
        prices_repo.set(
          adult_price: price_params[:adult_price],
          child_price: price_params[:child_price]
        )
        Success(nil)
      rescue PricesRepository::DbConnectionError
        Failure(nil)
      end
    end
  end
end
