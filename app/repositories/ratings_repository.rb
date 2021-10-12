# frozen_string_literal: true

class RatingsRepository
  def initialize(relation: Rating)
    @relation = relation
  end

  delegate :exists?, :all, to: :relation

  def create(movie_id:, user_id:, rate:)
    relation.create!(movie_id: movie_id, user_id: user_id, rate: rate)
  end

  private

  attr_reader :relation
end
