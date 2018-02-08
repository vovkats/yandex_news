FactoryBot.define do
  factory :ya_news do
    title  { Faker::Lorem.word }
    description { Faker::Lorem.sentence(3) }
    time { Time.at(Time.zone.now.to_i) }
  end
end