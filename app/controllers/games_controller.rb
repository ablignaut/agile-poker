class GamesController < ApplicationController
  before_action :set_game, only: %i[ show edit update destroy join player_vote clear_votes show_votes ]
  before_action :set_player, only: %i[ show join player_vote ]

  def player_vote
    GameChannel.broadcast(@game.id, @game.games_players)

    respond_to do |format|
      format.js
    end
  end

  def clear_votes
    @game.games_players.update_all(:complexity => nil, :amount_of_work => nil, :unknown_risk => nil)
    GameChannel.broadcast(@game.id, @game.games_players)

    respond_to do |format|
      format.js
    end
  end

  def show_votes
    # binding.pry
    GameChannel.broadcast_show_votes(@game.id, @game.games_players)

    respond_to do |format|
      format.js
    end
  end

  def join
    GameChannel.broadcast(@game.id, @game.games_players)
    respond_to do |format|
      format.html { redirect_to game_path(@game, { :games_player => { :name => @games_player.name } }), notice: "You have joined the game" }
    end
  end

  # GET /games or /games.json
  def index
    @games = Game.all
  end

  # GET /games/1 or /games/1.json
  def show
  end

  # GET /games/new
  def new
    @game = Game.new
  end

  # GET /games/1/edit
  def edit
  end

  # POST /games or /games.json
  def create
    @game = Game.new(game_params)

    respond_to do |format|
      if @game.save
        format.html { redirect_to @game, notice: "Game was successfully created." }
        format.json { render :show, status: :created, location: @game }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /games/1 or /games/1.json
  def update
    respond_to do |format|
      if @game.update(game_params)
        format.html { redirect_to @game, notice: "Game was successfully updated." }
        format.json { render :show, status: :ok, location: @game }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /games/1 or /games/1.json
  def destroy
    @game.destroy
    respond_to do |format|
      format.html { redirect_to games_url, notice: "Game was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game
      @game = Game.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def game_params
      params.require(:game).permit(:name, :amount_of_work_id, :complexity_id, :unknown_risk_id)
    end

    def set_player
      # why is this not working?
      # @games_player = @game.games_players.create_with(player_params).find_or_create_by!(:name => player_params[:name])
      # binding.pry
      if player_params[:name]
        @games_player = @game.games_players.find_or_create_by(:name => player_params[:name])
        @games_player.complexity = player_params[:complexity]
        @games_player.amount_of_work = player_params[:amount_of_work]
        @games_player.unknown_risk = player_params[:unknown_risk]
        @games_player.save!
      else
        @games_player = @game.games_players.new
      end
    end

    def player_params
      params.fetch(:games_player, {}).permit(:name, :complexity, :amount_of_work, :unknown_risk)
    end
end
