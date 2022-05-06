require "rails_helper"

feature 'User can index articles', %q{
  In order to read them.
}, js: true do

  let!(:articles) { create_list(:article, 5) }
  let(:article)   { articles.first }
  let(:user)      { create(:user) }

  background { sign_in(user) }

  describe "common" do
    it "displays articles list" do
      visit articles_path
      articles.each do |article|
        expect(page).to have_content(article.title)
      end
    end

    describe "presented time" do

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

  describe "lists" do
    let!(:source_one)           { create(:source) }
    let!(:source_two)           { create(:source) }
    let!(:source_one_articles)  { create_list(:article, 5, source: source_one) }
    let!(:source_two_articles)  { create_list(:article, 5, source: source_two) }
    let!(:list)                 { create(:list, user: user) }
    let!(:list_source)          { create(:list_source, list: list, source: source_one) }

    describe "click source" do
      it "filters source" do
        visit articles_path
        expect(page).to have_content source_one_articles.first.title
        expect(page).to have_content source_two_articles.first.title
        within(:css, '.sources') do 
          find(:css, 'a', text: source_one.title).click 
        end
        expect(page).to have_content source_one_articles.first.title
        expect(page).not_to have_content source_two_articles.first.title
      end
    end

    describe "click list" do
      it "filters relevant sources" do
        visit articles_path
        expect(page).to have_content source_one_articles.first.title
        expect(page).to have_content source_two_articles.first.title
        within(:css, '.lists') do 
          find(:css, 'a', text: list.title).click 
        end
        expect(page).to have_content source_one_articles.first.title
        expect(page).not_to have_content source_two_articles.first.title
      end
    end
  end
end