Source.create!(
  title: "Новая газета",
  base_url: "https://novayagazeta.eu",
  articles_path: "/news",
  title_xpath: "//h1",
  body_xpath: "//*[@id='article-body']",
  publication_date_xpath: "//time"
)

Source.create!(
  title: "Медуза",
  base_url: "https://meduza.io",
  articles_path: "",
  title_xpath: "//h1",
  body_xpath: "//*[@class='GeneralMaterial-article']",
  publication_date_xpath: "//*[@class='GeneralMaterial-head']//time",
)

user = User.create!(
  email: "customer@example.com",
  password: "xxxxxx"
)

3.times do |l|
  user.lists.create!(title: "title ##{l+1}")
end