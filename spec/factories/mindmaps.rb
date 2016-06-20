FactoryGirl.define do
  factory :mindmap do
    title Faker::Superhero.power
    description Faker::Hipster.sentence
    private false

    user_id nil
  end
end
