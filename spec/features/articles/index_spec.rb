require "rails_helper"

feature 'User can index articles', %q{
  In order to read them.
}, js: true do

  let!(:articles) { create_list(:article, 5) }
  let(:article)   { articles.first }

  background { sign_in(create(:user)) }

  it "displays articles list" do
    visit articles_path
    articles.each do |article|
      expect(page).to have_content(article.title)
    end
  end

  describe "display body" do
    describe "on load" do
      it "does not display body" do
        visit articles_path
        expect(page).to have_no_content(article.body)
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

  describe "mark read" do
    describe "first load" do
      it "displays bold article title" do
        visit articles_path
        expect(page).to have_css ".article_title.has-text-weight-bold"
      end
    end

    describe "on click" do
      it "removes bold style" do
        visit articles_path
        find(:css, ".article_title", text: article.title).click
        sleep(1)
        expect(page).to have_css(".article_title", text: article.title)
        expect(page).to have_no_css(".article_title.has-text-weight-bold", text: article.title)
      end
    end

    describe "second load" do
      background {
        visit articles_path
        find(:css, ".article_title", text: article.title).click
      }

      it "does not display bold style" do
        visit articles_path
        expect(page).to have_css(".article_title", text: article.title)
        expect(page).to have_no_css(".article_title.has-text-weight-bold", text: article.title)
      end
    end
  end
end