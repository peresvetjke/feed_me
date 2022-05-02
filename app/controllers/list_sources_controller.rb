class ListSourcesController < ApplicationController
  
  def create
    respond_to do |format|
      format.json do
        binding.break
        user_lists_ids = List.where(:user_id => current_user.id).only(:_id).map(&:id)
        @list_source = ListSource.where(:list_id.in => user_lists_ids, source_id: list_source_params[:source_id])&.first

        if @list_source.present? 
          @list_source.list_id = BSON::ObjectId.from_string(list_source_params[:list_id])
        else
          @list_source = ListSource.new(list_source_params)
        end

        # binding.break
        if @list_source.save
          render json: ListSourceSerializer.new(@list_source).serializable_hash.to_json
        else
          render json: ErrorSerializer.serialize(@list_source.errors), status: :unprocessable_entity
          # render json: ListSourceSerializer.new(@list_source).serializable_hash.to_json, status: :unprocessable_entity
        end
      end
    end
  end

  private

  def list_source_params
    params.require(:list_source).permit(:source_id, :list_id)
  end
end