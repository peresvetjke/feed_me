Source.create!(
  title: "Новая газета",
  base_url: "https://novayagazeta.eu",
  news_url: "https://novayagazeta.eu/news"
)

Source.create!(
  title: "Медуза",
  base_url: "https://meduza.io"
)

user = User.create!(
  email: "customer@example.com",
  password: "xxxxxx"
)

3.times do |l|
  user.lists.create!(title: "title ##{l+1}")
end