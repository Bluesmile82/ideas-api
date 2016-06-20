FactoryGirl.define do
  factory :idea do
    title Faker::Superhero.power
    x 0
    y 0
    size 5
    url Faker::Internet.url
    description Faker::Hipster.sentence
  end
end
