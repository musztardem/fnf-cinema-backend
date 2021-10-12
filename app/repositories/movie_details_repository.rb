# frozen_string_literal: true

class MovieDetailsRepository < CacheableRemoteRepository
  ConnectionError = Class.new(StandardError)
  DataInconsistencyError = Class.new(StandardError)

  def initialize(api_key: ENV['OMDB_API_KEY'])
    super()
    @api_key = api_key
  end

  def load(id:)
    response = get(url: url(id))
    transformed_response = transformed(response)
    raise ConnectionError if transformed_response[:error].present?

    MovieDetailsValue.new(transformed_response)
  rescue Faraday::ConnectionFailed => e
    CinemaApi.logger.error "API call failed: #{e}"
    raise ConnectionError
  rescue Dry::Struct::Error => e
    CinemaApi.logger.error "Data inconsistency detected: #{e}"
    raise DataInconsistencyError
  end

  private

  attr_reader :cacheable, :api_key

  def url(movie_id)
    "http://www.omdbapi.com/?apikey=#{api_key}&i=#{movie_id}"
  end

  def transformed(response)
    JSON.parse(response)
        .deep_transform_keys(&:underscore)
        .deep_symbolize_keys[:body]
  end
end
