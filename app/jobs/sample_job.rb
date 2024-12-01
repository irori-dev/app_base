class SampleJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do something later
    puts "I am a sample job"
  end
end
