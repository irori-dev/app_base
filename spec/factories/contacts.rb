FactoryBot.define do
  factory :contact, class: Contact do
    name { 'John Doe' }
    email { 'example@example.com' }
    text do
      'John Doe is a fictional character created by American writer John Steinbeck.'
    end
    phone_number { '09012345678' }
    created_at { Time.zone.now }
  end
end
