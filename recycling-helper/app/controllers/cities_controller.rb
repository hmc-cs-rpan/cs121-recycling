class CitiesController < ApplicationController
  before_action :set_city, only: [:show, :edit, :update, :destroy]

  # GET /cities
  # GET /cities.json
  def index
    @cities = City.all
  end

  # GET /cities/1
  # GET /cities/1.json
  def show
    @city = City.find(params[:id])
    @categories = Category.all
    @bins = @city.bins
  end

  # GET /cities/new
  def new
    @city = City.new
    @states = Geography::STATES
  end

  # GET /cities/1/edit
  def edit
  end

  def itemLookupResult
    render
  end

  # POST /cities
  # POST /cities.json
  def create
    @city = City.create(city_params)
    if @city.invalid?
      flash[:error] = @city.errors.full_messages
      render 'new'
    else
      bin = @city.add_bin! 'recycling'
      if params[:item_ids] && !params[:item_ids].empty?
        bin.items += Item.find(params[:item_ids])
      end
      flash[:success] = "#{@city.name}, #{@city.state} successfully created!"
      redirect_to @city
    end
  end

  # PATCH/PUT /cities/1
  # PATCH/PUT /cities/1.json
  def update
    respond_to do |format|
      if @city.update(city_params)
        format.html { redirect_to @city, notice: 'City was successfully updated.' }
        format.json { render :show, status: :ok, location: @city }
      else
        format.html { render :edit }
        format.json { render json: @city.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cities/1
  # DELETE /cities/1.json
  def destroy
    @city.destroy
    respond_to do |format|
      format.html { redirect_to cities_url, notice: 'City was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_city
      @city = City.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def city_params
      params.require(:city).permit(:name, :state, :zip)
    end


end
