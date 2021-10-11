# frozen_string_literal: true

FactoryBot.define do
  factory :rating do
    rate { 1 }
    user { nil }
  end
end
