# frozen_string_literal: true

class ApiBase < Grape::API
  format :json

  rescue_from Grape::Exceptions::ValidationErrors do |e|
    error!({ message: 'Invalid parameters', errors: e.full_messages }, 400)
  end

  rescue_from :all do |e|
    details = { type: e, message: e.message, backtrace: e.backtrace }
    CinemaApi.logger.error JSON.pretty_generate(details)
    error!(details, 500)
  end
end
