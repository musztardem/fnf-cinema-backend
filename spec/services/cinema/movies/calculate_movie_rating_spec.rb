# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Cinema::Movies::CalculateMovieRating do
  include Dry::Monads[:result, :do]

  subject(:service) { described_class.new(ratings_repo: ratings_repo_mock) }

  let(:ratings_repo_mock) { instance_double 'RatingsRepository', all_movie_ratings: movie_ratings }
  let(:movie_ratings) { [5, 5] }
  let(:movie_id) { 'any-id' }

  describe '#call' do
    context 'when movie has no ratings' do
      let(:movie_ratings) { [] }

      it 'returns Failure(nil)' do
        expect(service.call(movie_id: movie_id)).to eq(Failure(nil))
      end
    end

    context 'when movie has ratings' do
      it 'returns Success()' do
        expect(service.call(movie_id: movie_id)).to eq(Success(5))
      end
    end
  end
end
