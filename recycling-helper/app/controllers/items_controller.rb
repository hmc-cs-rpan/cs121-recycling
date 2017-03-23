class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy]

  # GET /items
  # GET /items.json
  def index
    @items = Item.all
  end

  # GET /items/1
  # GET /items/1.json
  def show
  @items = Item.find(params[:id])
  end

  # GET /items/new
  def new
    @item = Item.new
  end

  # GET /items/1/edit
  def edit
  end

  # POST /items
  # POST /items.json
  def create
    @item = Item.new(item_params)

    respond_to do |format|
      if save_item(@item)
        format.html { redirect_to @item }
        format.json { render json: {ok: true } }
      else
        format.html { render 'new' }
        format.json { render json: {ok: false, errors: @item.errors.full_messages } }
      end
    end

  end

  # PATCH/PUT /items/1
  # PATCH/PUT /items/1.json
  def update
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
      params.require(:item).permit(:name, :category_id)
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
