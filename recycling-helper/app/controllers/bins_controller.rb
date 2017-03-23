class BinsController < ApplicationController
  before_action :set_bin, only: [:show, :edit, :update, :destroy]

  # GET /bins
  # GET /bins.json
  def index
    @bins = Bin.all
  end

  # GET /bins/1
  # GET /bins/1.json
  def show
    @bin = Bin.find(params[:id])
  end

  # GET /bins/new
  def new
    @bin = Bin.new
  end

  # GET /bins/1/edit
  def edit
  end

  # POST /bins
  # POST /bins.json
  def create
    @bin = Bin.new(bin_params)

    respond_to do |format|
      if save_bin(@bin)
        format.html { redirect_to @bin, notice: 'Bin was successfully created.' }
        format.json { render json: { ok: true, bin: @bin } }
      else
        format.html { render :new }
        format.json { render json: { ok: false, errors: @bin.errors.full_messages } }
      end
    end
  end

  # PATCH/PUT /bins/1
  # PATCH/PUT /bins/1.json
  def update
    respond_to do |format|
      if @bin.update(bin_params)
        format.html { redirect_to @bin, notice: 'Bin was successfully updated.' }
        format.json { render :show, status: :ok, location: @bin }
      else
        format.html { render :edit }
        format.json { render json: @bin.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bins/1
  # DELETE /bins/1.json
  def destroy
    @bin.destroy
    respond_to do |format|
      format.html { redirect_to bins_url, notice: 'Bin was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bin
      @bin = Bin.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bin_params
      params.require(:bin).permit(:name, :city_id)
    end

    # Create a new bin and return a boolean indicating success
    def save_bin(bin)
      begin
        bin.save
      rescue ActiveRecord::RecordNotUnique
        bin.errors.add :base, :not_unique, message:
          "A bin with the name \"#{bin.name}\" already exists for this city."
      end

      return bin.errors.empty?
    end

end
