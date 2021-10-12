# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Cinema::Movies::GetDetails do
  include Dry::Monads[:result, :do]

  subject(:service) do
    described_class.new(
      movies_repo: movies_repo_mock,
      movie_details_repo: movie_details_repo_mock,
      movie_rating_service: rating_service_mock
    )
  end

  let(:movies_repo_mock) { instance_double 'MoviesRepository', exists?: movie_exists }
  let(:movie_details_repo_mock) do
    instance_double 'MovieDetailsRepository', load: movie_details_mock
  end
  let(:rating_service_mock) { instance_double 'CalculateMovieRating', call: calculation_result }

  let(:movie_exists) { true }
  let(:movie_details_mock) { instance_double 'MovieDetailsValue' }
  let(:calculation_result) { Success(5.0) }

  let(:movie_id) { 'movie-id' }

  describe '#call' do
    context 'when movie is not stored in the repository' do
      let(:movie_exists) { false }

      it 'returns Failure(:not_found)' do
        expect(service.call(movie_id: movie_id)).to eq(Failure(:not_found))
      end
    end

    context 'when details repository has ConnectionError' do
      before { allow(movie_details_repo_mock).to receive(:load).and_raise(MovieDetailsRepository::ConnectionError) }

      it 'returns Failure(nil)' do
        expect(service.call(movie_id: movie_id)).to eq(Failure(nil))
      end
    end

    context 'when details repository detects DataInconsistencyError' do
      before do
        allow(movie_details_repo_mock).to receive(:load).and_raise(MovieDetailsRepository::DataInconsistencyError)
      end

      it 'return Failure(nil)' do
        expect(service.call(movie_id: movie_id)).to eq(Failure(nil))
      end
    end
  end
end
