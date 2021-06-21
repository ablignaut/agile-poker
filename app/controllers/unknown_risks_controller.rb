class UnknownRisksController < ApplicationController
  before_action :set_unknown_risk, only: %i[ show edit update destroy ]

  # GET /unknown_risks or /unknown_risks.json
  def index
    @unknown_risks = UnknownRisk.all
  end

  # GET /unknown_risks/1 or /unknown_risks/1.json
  def show
  end

  # GET /unknown_risks/new
  def new
    @unknown_risk = UnknownRisk.new
  end

  # GET /unknown_risks/1/edit
  def edit
  end

  # POST /unknown_risks or /unknown_risks.json
  def create
    @unknown_risk = UnknownRisk.new(unknown_risk_params)

    respond_to do |format|
      if @unknown_risk.save
        format.html { redirect_to @unknown_risk, notice: "Unknown risk was successfully created." }
        format.json { render :show, status: :created, location: @unknown_risk }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @unknown_risk.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /unknown_risks/1 or /unknown_risks/1.json
  def update
    respond_to do |format|
      if @unknown_risk.update(unknown_risk_params)
        format.html { redirect_to @unknown_risk, notice: "Unknown risk was successfully updated." }
        format.json { render :show, status: :ok, location: @unknown_risk }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @unknown_risk.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /unknown_risks/1 or /unknown_risks/1.json
  def destroy
    @unknown_risk.destroy
    respond_to do |format|
      format.html { redirect_to unknown_risks_url, notice: "Unknown risk was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_unknown_risk
      @unknown_risk = UnknownRisk.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def unknown_risk_params
      params.require(:unknown_risk).permit(:none, :low, :some, :many)
    end
end
