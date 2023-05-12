FactoryBot.define do
    factory :user do
      sequence :uid do |n|
        "uid-#{n}"
      end
      password { 'password' }
    end
  end
  