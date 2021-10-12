# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PricesRepository do
  subject(:service) { described_class.new(redis: redis_stub) }

  let(:redis_stub) { RedisStub.new }

  describe 'set' do
    context 'when successfully set' do
      it 'returns OK' do
        expect(service.set(adult_price: 10, child_price: 5)).to eq 'OK'
      end
    end

    context 'when cannot establish connection' do
      before { allow(redis_stub).to receive(:mset).and_raise(Redis::CannotConnectError) }

      it 'throws DbConnectionError' do
        expect { service.set(adult_price: 10, child_price: 5) }
          .to raise_error(PricesRepository::DbConnectionError)
      end
    end
  end

  describe 'get' do
    context 'when successfuly get' do
      before { redis_stub.mset('adult_price', 10, 'child_price', 5) }

      it 'returns PricesValue object' do
        expect(service.get).to be_a PricesValue
      end
    end

    context 'when cannot establish connection' do
      before { allow(redis_stub).to receive(:mget).and_raise(Redis::CannotConnectError) }

      it 'throws DbConnectionError' do
        expect { service.get }.to raise_error(PricesRepository::DbConnectionError)
      end
    end

    context 'when prices are not stored' do
      before { redis_stub.mset('adult_price', nil, 'child_price', nil) }

      it 'returns nil' do
        expect(service.get).to be_nil
      end
    end

    context 'when prices does not match expected schema' do
      before { redis_stub.mset('adult_price', 'dfd', 'child_price', 'example') }

      it 'throws DataInconsistencyError' do
        expect { service.get }.to raise_error(PricesRepository::DataInconsistencyError)
      end
    end
  end
end
