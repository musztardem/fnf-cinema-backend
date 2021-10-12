# frozen_string_literal: true

class CacheableRemoteRepository
  def initialize(http_client: Faraday, cache_store: Redis.current,
                 cache_enabled: ENV['CACHE_ENABLED'])
    @http_client = http_client
    @cache_store = cache_store
    @cache_enabled = cache_enabled
  end

  def get(url:)
    return status_and_body(http_client.get(url)) unless cache_enabled

    cached_response = fetch_from_cache(url)
    return cached_response if cached_response.present?

    response = status_and_body(http_client.get(url))
    set_cache(url, response) if successful_response?(response)

    response
  end

  private

  attr_reader :http_client, :cache_store, :cache_enabled

  def fetch_from_cache(url)
    cache_store.get(url)
  end

  def set_cache(url, response)
    cache_store.setex(url, 1.hour, response)
  end

  def successful_response?(response)
    parsed_response = JSON.parse(response)
    transformed_response = parsed_response.deep_transform_keys(&:underscore).deep_symbolize_keys
    # API seems to always respond with status 200 even when there's an error
    # and we want cache only responses with { response: "True" }
    transformed_response[:status] == 200 &&
      Types::Params::Bool[transformed_response[:body][:response]]
  end

  def status_and_body(response)
    { status: response.status, body: JSON.parse(response.body) }.to_json
  end
end
