class AmountOfWorksController < ApplicationController
  before_action :set_amount_of_work, only: %i[ show edit update destroy ]

  # GET /amount_of_works or /amount_of_works.json
  def index
    @amount_of_works = AmountOfWork.all
  end

  # GET /amount_of_works/1 or /amount_of_works/1.json
  def show
  end

  # GET /amount_of_works/new
  def new
    @amount_of_work = AmountOfWork.new
  end

  # GET /amount_of_works/1/edit
  def edit
  end

  # POST /amount_of_works or /amount_of_works.json
  def create
    @amount_of_work = AmountOfWork.new(amount_of_work_params)

    respond_to do |format|
      if @amount_of_work.save
        format.html { redirect_to @amount_of_work, notice: "Amount of work was successfully created." }
        format.json { render :show, status: :created, location: @amount_of_work }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @amount_of_work.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /amount_of_works/1 or /amount_of_works/1.json
  def update
    respond_to do |format|
      if @amount_of_work.update(amount_of_work_params)
        format.html { redirect_to @amount_of_work, notice: "Amount of work was successfully updated." }
        format.json { render :show, status: :ok, location: @amount_of_work }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @amount_of_work.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /amount_of_works/1 or /amount_of_works/1.json
  def destroy
    @amount_of_work.destroy
    respond_to do |format|
      format.html { redirect_to amount_of_works_url, notice: "Amount of work was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_amount_of_work
      @amount_of_work = AmountOfWork.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def amount_of_work_params
      params.require(:amount_of_work).permit(:tiny, :little, :fair, :large, :huge)
    end
end
