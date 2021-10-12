# frozen_string_literal: true

class ShowingsRepository
  def initialize(relation: Showing)
    @relation = relation
  end

  delegate :all, to: :relation

  def load(id:)
    relation.find_by(id: id)
  end

  def create(movie_id:, projection_date:)
    relation.create!(movie_id: movie_id, projection_date: projection_date)
  end

  def update(id:, projection_date:)
    load(id: id).update!(projection_date: projection_date)
  end

  def showing_for_movie?(id:, movie_id:)
    relation.exists?(id: id, movie_id: movie_id)
  end

  def list_showings_for_movie(movie_id:)
    relation.where(movie_id: movie_id)
  end

  private

  attr_reader :relation
end
