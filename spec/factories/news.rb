FactoryBot.define do
  factory :news do
    title  { Faker::Lorem.word }
    description { Faker::Lorem.sentence(3) }
    time { Time.at(Time.zone.now.to_i) }
    show_until { Time.zone.now + 10.seconds }

    user
  end
end