FactoryGirl.define do
  factory :review do
    rating { 1 + rand(5) }
    comments { Faker::Lorem.sentences(5) }
    user_id { User.all.pluck(:id).sample }
    lacquer_id { Lacquer.all.pluck(:id).sample }
  end
end
