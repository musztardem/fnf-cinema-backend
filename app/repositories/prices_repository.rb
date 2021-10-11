# frozen_string_literal: true

class PricesRepository
  ADULT_KEY = 'adult_price'
  CHILD_KEY = 'child_price'

  DbConnectionError = Class.new(StandardError)
  DataInconsistencyError = Class.new(StandardError)

  def initialize(redis: Redis.current)
    @redis = redis
  end

  def set(adult_price:, child_price:)
    safe_perform { redis.mset(ADULT_KEY, adult_price, CHILD_KEY, child_price) }
  end

  def get
    prices = safe_perform { redis.mget(ADULT_KEY, CHILD_KEY) }
    return nil if prices.all?(&:blank?)

    build_value_object(prices)
  end

  private

  attr_reader :redis

  def safe_perform(&db_call)
    yield db_call
  rescue Redis::CannotConnectError
    raise DbConnectionError
  end

  def build_value_object(prices)
    ::PricesValue.new(adult_price: prices[0], child_price: prices[1])
  rescue Dry::Struct::Error
    raise DataInconsistencyError
  end
end
