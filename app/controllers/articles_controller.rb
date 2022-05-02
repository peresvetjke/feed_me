class ArticlesController < ApplicationController
  before_action :load_common, only: [:index, :search]

  def index
  end

  def search
    if search_params[:lists].present?
      list = List.find(BSON::ObjectId.from_string(search_params[:lists].first))
      sources = list.list_sources.map{ |list_source| list_source.source }
    elsif search_params[:sources].present?
      sources = search_params[:sources].map { |id| BSON::ObjectId.from_string(id) }
    else
      sources = Source.all
    end
    
    articles = Article.where(:source.in => sources)

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
      sources: [], 
      lists: []
    )
  end
end