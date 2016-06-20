FactoryGirl.define do
  factory :role do
    name RoleName.enum(:admin)
  end
end
