class BinsController < ApplicationController
  before_action :set_bin, only: [:update, :destroy]

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
        format.json {
          bin = Bin.find_by(id: @bin.id) || {}
          render json:
          { ok: false, errors: @bin.errors.full_messages, bin: bin }
        }
      end
    end
  end

  # PATCH/PUT /bins/1
  # PATCH/PUT /bins/1.json
  def update
    Rails.logger.debug bin_params[:color]
    @bin.assign_attributes bin_params

    respond_to do |format|
      if save_bin @bin
        format.html { redirect_to @bin, notice: 'Bin was successfully updated.' }
        format.json { render json: { ok: true, bin: @bin } }
      else
        Rails.logger.error "Failed to update bin #{params[:id]}"
        format.html { render :edit }
        format.json { render json: {
          # Respond with the current state of the bin in the database
          ok: false, errors: @bin.errors.full_messages, bin: Bin.find_by(id: params[:id]) }
        }
      end
    end
  end

  # DELETE /bins/1
  # DELETE /bins/1.json
  def destroy
    @bin.destroy
    respond_to do |format|
      format.html { redirect_to bins_url, notice: 'Bin was successfully destroyed.' }
      format.json { render json: { ok: true } }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bin
      @bin = Bin.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bin_params
      params.require(:bin).permit(:name, :city_id, :color)
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
