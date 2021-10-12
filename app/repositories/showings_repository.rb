# frozen_string_literal: true

class ShowingsRepository
  def initialize(relation: Showing)
    @relation = relation
  end

  delegate :all, to: :relation

  private

  attr_reader :relation
end
