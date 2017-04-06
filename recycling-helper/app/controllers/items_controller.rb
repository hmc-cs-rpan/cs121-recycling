class ItemsController < ApplicationController
  before_action :set_item, only: [:update, :destroy]

  # POST /items
  # POST /items.json
  def create
    @item = Item.new(item_params)
    @item.image = Item.find(params[:image])

    respond_to do |format|
      if save_item(@item)
        format.html { redirect_to @item }
        format.json { render json: { ok: true, item: @item } }
      else
        format.html { render 'new' }
        format.json { render json: { ok: false, errors: @item.errors.full_messages } }
      end
    end

  end

  # PATCH/PUT /items/1
  # PATCH/PUT /items/1.json
  def update
    Rails.logger.debug bin_params[:image]
    @bin.assign_attributes bin_params
    respond_to do |format|
      if @item.update(item_params)
        format.html { redirect_to @item, notice: 'Item was successfully updated.' }
        format.json { render :show, status: :ok, location: @item }
      else
        format.html { render :edit }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
    @item.destroy
    respond_to do |format|
      format.html { redirect_to items_url, notice: 'Item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def item_params
      params.require(:item).permit(:name, :category_id, :image)
    end

    # Create a new item and return a boolean indicating success
    def save_item(item)
      begin
        item.save
      rescue ActiveRecord::RecordNotUnique
        item.errors.add :base, :not_unique, message:
          "An item with the name \"#{item.name}\" already exists " +
          "(in the category \"#{Item.find_by(name: item.name).category.name}\")"
      end

      return item.errors.empty?
    end
end
