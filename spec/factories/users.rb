FactoryGirl.define do
  factory :user do
    trait :admin do
      email "admin@test.com"
    end
    trait :user do
      email "user@test.com"
    end
    trait :guest do
      email "guest@test.com"
    end

    password = Faker::Internet.password
    password password
    password_confirmation password
  end
end
