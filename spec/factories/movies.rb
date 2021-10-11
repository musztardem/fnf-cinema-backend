# frozen_string_literal: true

FactoryBot.define do
  factory :movie do
    id { "tt#{Faker::Number.number(digits: 7)}" }
  end
end
