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
  let(:movie_details_repo_mock) { instance_double 'MovieDetailsRepository', load: movie_details }
  let(:rating_service_mock) do
    include_dry_matcher(Cinema::Movies::CalculateMovieRating, call: calculation_result)
  end

  let(:movie_exists) { true }
  let(:movie_details) do
    MovieDetailsValue.new(imdb_id: '1', title: 'a', plot: 'b', released: 'c',
                          imdb_rating: '3', runtime: '23')
  end

  let(:calculation_result) { Success(BigDecimal(5)) }

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

    context 'when users rating cannot be calculated' do
      let(:calculation_result) { Failure(nil) }

      it 'returns result with users rating = 0' do
        result = service.call(movie_id: movie_id).value!
        expect(result.users_rating).to eq(0.0)
      end
    end

    context 'when users rating is successfully calculated' do
      it 'returns result with calculated users rating' do
        result = service.call(movie_id: movie_id).value!
        expect(result.users_rating).to eq(5.0)
      end
    end
  end
end
