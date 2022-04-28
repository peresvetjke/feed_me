Source.create!(
  title: "Новая газета",
  base_url: "https://novayagazeta.eu",
  articles_path: "/news",
  article_css: "article",
  title_css: "h1",
  body_css: "#article-body",
  publication_date_css: "time"
)

Source.create!(
  title: "Медуза",
  base_url: "https://meduza.io",
  articles_path: "",
  article_css: "article",
  title_css: "h1",
  body_css: ".GeneralMaterial-article",
  publication_date_css: ".GeneralMaterial-head time",
)

User.create!(
  email: "customer@example.com",
  password: "xxxxxx"
)