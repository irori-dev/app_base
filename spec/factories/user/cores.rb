FactoryBot.define do
  factory :user_core, class: User::Core do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { 'password' }
    password_confirmation { 'password' }
  end
end
