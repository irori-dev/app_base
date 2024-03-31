FactoryBot.define do
  factory :admin do
    sequence(:email) { |n| "admin#{n}@example.com" }
    password { 'password' }
    password_confirmation { 'password' }
  end
end
