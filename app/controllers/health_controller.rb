# frozen_string_literal: true

class HealthController < ApplicationController

  skip_before_action :verify_authenticity_token

  def index
    render json: health_status, status: overall_status
  end

  private

  def health_status
    {
      status: overall_status == :ok ? 'healthy' : 'unhealthy',
      timestamp: Time.current.iso8601,
      checks: {
        database: database_check,
        cache: cache_check,
        queue: queue_check,
      },
    }
  end

  def overall_status
    if database_check[:status] == 'ok' && cache_check[:status] == 'ok' && queue_check[:status] == 'ok'
      :ok
    else
      :service_unavailable
    end
  end

  def database_check
    ActiveRecord::Base.connection.execute('SELECT 1')
    { status: 'ok', message: 'Database is responding' }
  rescue StandardError => e
    { status: 'error', message: "Database connection failed: #{e.message}" }
  end

  def cache_check
    Rails.cache.write('health_check', 'ok', expires_in: 10.seconds)
    value = Rails.cache.read('health_check')

    if value == 'ok'
      { status: 'ok', message: 'Cache is working' }
    else
      { status: 'error', message: 'Cache read/write failed' }
    end
  rescue StandardError => e
    { status: 'error', message: "Cache check failed: #{e.message}" }
  end

  def queue_check
    # Solid Queueの接続確認
    SolidQueue::Job.connection.execute('SELECT 1')
    { status: 'ok', message: 'Queue database is responding' }
  rescue StandardError => e
    { status: 'error', message: "Queue check failed: #{e.message}" }
  end

end
