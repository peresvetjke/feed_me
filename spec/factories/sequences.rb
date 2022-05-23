FactoryBot.define do
  sequence(:title)    { |n| "Title #{n}" }
  sequence(:url)      { |n| "/path/to/#{n}" }
  sequence(:email)    { |n| "user#{n}@example.com" }
  sequence(:base_url) { |n| "https://www.example#{n}.com" }
end