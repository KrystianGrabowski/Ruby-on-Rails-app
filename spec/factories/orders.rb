FactoryBot.define do
  factory :order do
    owner_id { Faker::Number }
    owner_type { 'User' }
    status { '' }
  end
end
