# frozen_string_literal: true

GrapeSwaggerRails.options.url = '/v1_swagger.json'
GrapeSwaggerRails.options.before_action do
  GrapeSwaggerRails.options.app_url = request.protocol + request.host_with_port
end
