FactoryBot.define do
  factory :comment do
    body { "MyText" }
    article
    user
  end
end
