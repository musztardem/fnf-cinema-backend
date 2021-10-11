# frozen_string_literal: true

Rails.application.routes.draw do
  mount CinemaApi => '/'
  mount CinemaAdminApi => '/'
end
