# frozen_string_literal: true

class MovieDetailsValue < Dry::Struct
  attribute :imdb_id, Types::Strict::String
  attribute :title, Types::Strict::String
  attribute :plot, Types::Strict::String
  attribute :released, Types::Strict::String
  attribute :imdb_rating, Types::Strict::String
  attribute :runtime, Types::Strict::String
end
