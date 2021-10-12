# frozen_string_literal: true

class ShowingsRepository
  def initialize(relation: Showing)
    @relation = relation
  end

  delegate :all, to: :relation

  def create(movie_id:, projection_date:)
    relation.create!(movie_id: movie_id, projection_date: projection_date)
  end

  private

  attr_reader :relation
end
