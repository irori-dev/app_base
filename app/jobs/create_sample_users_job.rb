class CreateSampleUsersJob < ApplicationJob
  queue_as :default

  def perform(*args)
    count = args[0]
    chars = ("a".."z").to_a
    count.times do |i|
      User::Core.create(email: "#{8.times.map { chars.sample }.join}@example.com", password: "password")
      puts "Created #{i + 1} users"
      sleep 3
    end
  end
end
