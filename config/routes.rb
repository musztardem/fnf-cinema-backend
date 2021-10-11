# frozen_string_literal: true

Rails.application.routes.draw do
  mount CinemaApi => '/'
  mount CinemaAdminApi => '/'

  mount GrapeSwaggerRails::Engine => '/swagger' if Rails.env.development?
end
