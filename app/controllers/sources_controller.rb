class SourcesController < ApplicationController
  before_action :load_sources,      only: :index
  before_action :load_source,       only: [:assign_to_list, :clear_assignment]
  before_action :load_lists,        only: :index
  before_action :load_list_sources, only: :index

  def index
  end

  def assign_to_list
    list = List.find(BSON::ObjectId.from_string(list_params[:id]))
    @source.assign_to_list!(list)
  end

  def clear_assignment
    @source.clear_assignment!(current_user)
  end

  private

  def list_params
    params.require(:list).permit(:id)
  end

  def load_source
    @source = Source.find(params[:id])
  end

  def load_sources
    @sources = Source.all
  end

  def load_lists
    @lists = current_user.lists
  end

  def load_list_sources
    # user_lists_ids = current_user.lists.only(:_id).map(&:id)
    lists_ids = @lists.only(:_id).map(&:id)
    # @list_sources = ListSource.where(:list_id.in => user_lists_ids).map do |ls| 
    #   { ls.source.id => ls.list.id }
    # end
    @list_sources = ListSource.where(:list_id.in => lists_ids)
  end
end