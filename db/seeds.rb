Source.create!(
  title: "Новая газета",
  base_url: "https://novayagazeta.eu",
  articles_path: "/news"
)

User.create!(
  email: "customer@example.com",
  password: "xxxxxx"
)

UpdatesManager.new.call