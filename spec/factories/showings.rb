# frozen_string_literal: true

FactoryBot.define do
  factory :showing do
    projection_date { Faker::Number.number(digits: 1).days.from_now }
    movie
  end
end
