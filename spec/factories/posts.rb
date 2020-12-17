FactoryBot.define do
  factory :post do
    title { "MyString" }
    body { "MyText" }
    published_at { "2020-12-17 15:14:23" }
    user { nil }
  end
end
