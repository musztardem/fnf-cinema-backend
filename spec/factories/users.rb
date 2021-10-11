# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    username { Faker::Internet.email }
    role { 'moviegoer' }
  end

  trait(:admin) do
    role { 'admin' }
  end
end
