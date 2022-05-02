class ListsController < ApplicationController
  before_action :load_list, only: %i[show edit update destroy]

  def index
    @lists = current_user.lists
  end

  def show
  end

  def create
    @list = current_user.lists.new(list_params)

    respond_to do |format|
      format.turbo_stream {
        if @list.save
          render turbo_stream: 
            [
              turbo_stream.replace("notice", partial: "shared/notice", locals: {notice: "List was successfully created."}),
              turbo_stream.replace("new_list", partial: "lists/form", locals: { list: List.new }),
              turbo_stream.append("lists", partial: "lists/list", locals: { list: @list} )
            ]
        else
          render turbo_stream: turbo_stream.replace("new_list", partial: "lists/form", locals: { list: @list })
        end
      }
    end
  end
  
  def edit
  end

  def update
    respond_to do |format|
      if @list.update(list_params)
        format.turbo_stream { 
          render turbo_stream: 
            [
              turbo_stream.replace("notice", partial: "shared/notice", locals: {notice: "List was successfully updated."}),
              turbo_stream.replace(dom_id(@list), partial: "lists/list", locals: {list: @list})
            ]
        }
      else
        format.turbo_stream { 
          render turbo_stream: turbo_stream.replace(@list, partial: "lists/form", locals: { list: @list }) 
        }
      end
    end
  end

  def destroy
    respond_to do |format|
      format.turbo_stream {
        list = @list
        @list.destroy
        render turbo_stream: 
          [
            turbo_stream.remove(list),
            turbo_stream.replace("notice", partial: "shared/notice", locals: {notice: "List was successfully deleted."}) 
          ]
        
      }
    end
  end

  private

  def load_list
    @list = List.find(params[:id])
  end

  def list_params
    params.require(:list).permit(:title)
  end
end