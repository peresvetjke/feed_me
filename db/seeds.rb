Source.create!(
  title: "Новая газета",
  base_url: "https://novayagazeta.eu",
  news_url: "https://novayagazeta.eu/news",
  time_zone: "Moscow"
)

Source.create!(
  title: "Медуза",
  base_url: "https://meduza.io",
  time_zone: "Moscow"
)

user = User.create!(
  email: "customer@example.com",
  password: "xxxxxx"
)

3.times do |l|
  user.lists.create!(title: "title ##{l+1}")
end