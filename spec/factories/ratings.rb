# frozen_string_literal: true

FactoryBot.define do
  factory :rating do
    rate { Faker::Number.between(from: 1, to: 5) }
    user
  end
end
