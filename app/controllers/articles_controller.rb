class ArticlesController < ApplicationController
  before_action :load_common, only: [:index, :search]

  def index
  end

  def retrieve_updates
    UpdateArticlesJob.perform_async
  end

  def search
    articles = Article.search_articles(search_params)
    render turbo_stream: turbo_stream.replace("#{current_user.id}_articles", partial: "articles", locals: { articles: articles })
  end

  def mark_read
    @article = Article.find(params[:id])
    @article.mark_read!(user: current_user)
  end

  private

  def load_common
    @articles = Article.all
    @sources = Source.all
    @lists = current_user.lists
    @read_articles = Article.read_by(current_user)
  end

  def search_params
    params.require(:search).permit(
      :query,
      sources: [], 
      lists: []
    )
  end
end