# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Health Check', type: :request do
  describe 'GET /health' do
    it 'returns healthy status when all checks pass' do
      get '/health'

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to match(a_string_including('application/json'))

      json = JSON.parse(response.body)
      expect(json['status']).to eq('healthy')
      expect(json['checks']['database']['status']).to eq('ok')
      expect(json['checks']['cache']['status']).to eq('ok')
      expect(json['checks']['queue']['status']).to eq('ok')
    end

    it 'includes timestamp in response' do
      get '/health'

      json = JSON.parse(response.body)
      expect(json['timestamp']).to be_present
      expect { Time.parse(json['timestamp']) }.not_to raise_error
    end

    context 'when database is down' do
      before do
        allow(ActiveRecord::Base.connection).to receive(:execute).and_raise(StandardError, 'Connection failed')
      end

      it 'returns unhealthy status' do
        get '/health'

        expect(response).to have_http_status(:service_unavailable)

        json = JSON.parse(response.body)
        expect(json['status']).to eq('unhealthy')
        expect(json['checks']['database']['status']).to eq('error')
        expect(json['checks']['database']['message']).to include('Connection failed')
      end
    end

    context 'when cache is down' do
      before do
        allow(Rails.cache).to receive(:write).and_raise(StandardError, 'Cache error')
      end

      it 'returns unhealthy status' do
        get '/health'

        expect(response).to have_http_status(:service_unavailable)

        json = JSON.parse(response.body)
        expect(json['status']).to eq('unhealthy')
        expect(json['checks']['cache']['status']).to eq('error')
        expect(json['checks']['cache']['message']).to include('Cache error')
      end
    end

    context 'when queue is down' do
      before do
        allow(SolidQueue::Job.connection).to receive(:execute).and_raise(StandardError, 'Queue error')
      end

      it 'returns unhealthy status' do
        get '/health'

        expect(response).to have_http_status(:service_unavailable)

        json = JSON.parse(response.body)
        expect(json['status']).to eq('unhealthy')
        expect(json['checks']['queue']['status']).to eq('error')
        expect(json['checks']['queue']['message']).to include('Queue error')
      end
    end

    it 'does not require authentication' do
      get '/health'
      expect(response).to have_http_status(:ok)
    end

    it 'does not verify authenticity token' do
      post '/health'
      expect(response).not_to have_http_status(:unprocessable_entity)
    end
  end
end
