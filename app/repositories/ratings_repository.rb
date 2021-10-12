# frozen_string_literal: true

class RatingsRepository
  def initialize(relation: Rating)
    @relation = relation
  end

  delegate :exists?, :all, to: :relation

  def all_movie_ratings(movie_id:)
    relation.where(movie_id: movie_id).collect(&:rate)
  end

  def create(movie_id:, user_id:, rate:)
    relation.create!(movie_id: movie_id, user_id: user_id, rate: rate)
  end

  private

  attr_reader :relation
end
