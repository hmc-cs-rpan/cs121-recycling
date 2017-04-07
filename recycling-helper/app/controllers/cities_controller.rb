class CitiesController < ApplicationController
  before_action :set_city, except: [:index, :by_location, :search]
  before_action :empty_cities
  before_action :set_query

  # GET /cities
  # GET /cities.json
  def index
  end


  # GET /cities/1
  # GET /cities/1.json
  def show
    @city = City.find(params[:id])
  end

  # GET /cities/1/edit
  def edit
  end

  def itemLookupResult
    render
  end

  # GET /cities/find/location?latitude=:latitude&longitude=:longitude
  def by_location
    Rails.logger.debug(params[:latitude].to_f)
    Rails.logger.debug(params[:longitude].to_f)
    nearby = City.near([params[:latitude].to_f, params[:longitude].to_f], 20)
    if nearby.first
      redirect_to nearby.first
    else
      flash[:error] = "We couldn't find any cities near you."
      redirect_to '/cities'
    end
  end

  # GET /cities/search?query=:query
  def search
    if params[:query].nil? || params[:query] == ""
      redirect_to cities_path
      return
    end

    @query = params[:query].strip
    Rails.logger.debug "Processing query for city: #{@query}"

    # Try interpreting the query as a zip code
    zip = ZipCode.find_by name: @query
    if zip
      redirect_to zip.city
      Rails.logger.debug "Found city #{@query} by zip code"
      return
    end

    tokens = @query.split(',').map { |tok| tok.strip }

    if tokens.length == 1
      Rails.logger.debug "Searching for city named #{@query}"
      @cities = City.find_by_fuzzy_name(tokens[0].titleize)
    elsif tokens.length == 2
      # Try interpreting the query as a City, State pair
      name = tokens[0].titleize
      state = tokens[1].titleize
      if state.length == 2
        # If the state field corresponds to a postal abbreviation, use it. Otherwise, we'll treat it
        # as a state name and try to fuzzy match it.
        state = Geography.abbreviation_to_state(state.upcase) || state
      end

      Rails.logger.debug "Searching for city: #{name}, #{state}"

      # See if there's an exact match first
      @cities = City.where(state: state).where(name: name)
      unless @cities.length == 1
        Rails.logger.debug "No match or ambiguous match for #{name}, #{state}; falling back to fuzzy search"
        @cities = City.fuzzy_search(state: state, name: name)
      end
    else
      Rails.logger.debug "Malformed query #{@query}"
      flash[:error] =
        "Unable to process query \"#{@query}\". Enter a zip code, city, or \"City, State\" pair."
      render 'index'
      return
    end

    if @cities.empty?
      Rails.logger.debug "No results for query #{@query}"
      flash[:error] = "We couldn't find any cities matching \"#{@query}\"."
      render 'index'
    elsif @cities.length == 1
      Rails.logger.debug "Found exact match for #{@query}, redirecting to city #{@cities.first.id}"
      redirect_to @cities.first
    else
      # Display the list of matches
      Rails.logger.debug "Found #{@cities.length} matches for #{@query}"
      render 'index'
    end

  end

  # GET /cities/1/search
  def search_items
    if params[:query].nil? || params[:query] == ""
      render :show
      return
    end

    @query = params[:query].strip
    Rails.logger.debug "city #{@city.id}: Processing query for item #{@query}"

    @items = Item.find_by_fuzzy_name(@query) & @city.items
    if @items.empty?
      Rails.logger.debug "city #{@city.id}: No results for #{@query}"
      flash[:error] = "No items match #{@query}"
    end
    render :show
  end

  # PATCH/PUT /cities/1
  # PATCH/PUT /cities/1.json
  def update
    respond_to do |format|
      if @city.update(city_params)
        format.html { redirect_to @city, notice: 'City was successfully updated.' }
        format.json { render json: { ok: true, city: @city } }
      else
        format.html { render :edit }
        format.json { render json: { ok: false, errors: @city.errors.full_messages } }
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

    def empty_cities
      @cities = []
    end

    def set_query
      @query = ""
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def city_params
      params.require(:city).permit(:name, :state, :website_url)
    end


end
