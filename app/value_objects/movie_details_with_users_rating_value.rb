# frozen_string_literal: true

class MovieDetailsWithUsersRatingValue < Dry::Struct
  attribute :imdb_id, Types::Strict::String
  attribute :title, Types::Strict::String
  attribute :plot, Types::Strict::String
  attribute :released, Types::Strict::String
  attribute :imdb_rating, Types::Coercible::String
  attribute :runtime, Types::Strict::String
  attribute :users_rating, Types::Strict::Decimal
end
