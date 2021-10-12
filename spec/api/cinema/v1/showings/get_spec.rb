# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /api/v1/movies/{movieId}/showings', type: :request do
  include Dry::Monads[:result]

  subject(:request) { send request_method, path, params: params, headers: headers }

  let(:request_method) { :get }
  let(:path) { '/api/v1/movies/tt1234567/showings' }
  let(:params) { {} }
  let(:headers) { { 'Authorization' => create(:user).id } }

  let(:showing) { create :showing }

  context 'when user is not authorized' do
    let(:headers) { {} }

    before { request }

    it 'returns status 401 (:unauthorized)' do
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns error message' do
      expect(json_response['error']).to eq('Unauthorized')
    end
  end

  context 'when user is authorized' do
    let(:service_mock) { stub_with_dry_matcher(Cinema::Showings::Get, call: call_result) }

    before do
      allow(Cinema::Showings::Get).to receive(:new).and_return(service_mock)
      request
    end

    context 'when requested movie does not exist' do
      let(:call_result) { Failure(:not_found) }

      it 'returns status 404 (:not_found)' do
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when unknown failure happens' do
      let(:call_result) { Failure(nil) }

      it 'returns status 503 (:service_unavailable)' do
        expect(response).to have_http_status(:service_unavailable)
      end
    end

    context 'when success' do
      let(:call_result) { Success(create(:showing)) }

      it 'returns status 200 (:ok)' do
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
