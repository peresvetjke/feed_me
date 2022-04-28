class ArticlesController < ApplicationController
 
  def index
    @articles = Article.all
    @read_articles = Article.read_by(current_user)
  end

  def mark_read
    @article = Article.find(params[:id])
    @article.mark_read!(user: current_user)
  end
end