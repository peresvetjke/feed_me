require "rails_helper"

feature 'User can index articles', %q{
  In order to read them.
}, js: true do

  let!(:articles) { create_list(:article, 5) }
  let(:article)   { articles.first }

  it "displays articles list" do
    visit articles_path
    articles.each do |article|
      expect(page).to have_content(article.title)
    end
  end

  describe "on click" do
    it "displays body" do
      visit articles_path
      expect(page).to have_no_content(article.body)
      find(:css, ".article_title", text: article.title).click
      sleep(1)
      expect(page).to have_content(article.body)
    end
  end
end