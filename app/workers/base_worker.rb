class BaseWorker
  include Sidekiq::Worker
  sidekiq_options queue: :test, retry: 5
end
