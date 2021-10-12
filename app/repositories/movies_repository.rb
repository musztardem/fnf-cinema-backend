# frozen_string_literal: true

class MoviesRepository
  def initialize(relation: Movie)
    @relation = relation
  end

  delegate :exists?, to: :relation

  private

  attr_reader :relation
end
