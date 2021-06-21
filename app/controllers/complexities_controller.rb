class ComplexitiesController < ApplicationController
  before_action :set_complexity, only: %i[ show edit update destroy ]

  # GET /complexities or /complexities.json
  def index
    @complexities = Complexity.all
  end

  # GET /complexities/1 or /complexities/1.json
  def show
  end

  # GET /complexities/new
  def new
    @complexity = Complexity.new
  end

  # GET /complexities/1/edit
  def edit
  end

  # POST /complexities or /complexities.json
  def create
    @complexity = Complexity.new(complexity_params)

    respond_to do |format|
      if @complexity.save
        format.html { redirect_to @complexity, notice: "Complexity was successfully created." }
        format.json { render :show, status: :created, location: @complexity }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @complexity.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /complexities/1 or /complexities/1.json
  def update
    respond_to do |format|
      if @complexity.update(complexity_params)
        format.html { redirect_to @complexity, notice: "Complexity was successfully updated." }
        format.json { render :show, status: :ok, location: @complexity }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @complexity.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /complexities/1 or /complexities/1.json
  def destroy
    @complexity.destroy
    respond_to do |format|
      format.html { redirect_to complexities_url, notice: "Complexity was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_complexity
      @complexity = Complexity.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def complexity_params
      params.require(:complexity).permit(:none, :little, :fair, :complex, :very_complex)
    end
end
