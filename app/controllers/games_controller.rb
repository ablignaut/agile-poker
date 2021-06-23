class GamesController < ApplicationController
  before_action :set_game, only: %i[ show edit update destroy join player_vote ]
  before_action :set_player, only: %i[ show join player_vote ]
  before_action :set_players_session, only: %i[ show join player_vote ]

  def update_player_vote(player)
    # binding.pry
    p = session["players_#{@game.id}"].find{|players| players[:name.to_s] == player.name}
    session["players_#{@game.id}"].delete(p)
    add_player(player)
  end

  def add_player(player)
    # binding.pry
    session["players_#{@game.id}"] << player.serializable_hash
  end

  def player_vote
    # binding.pry
    update_player_vote(@player)
    # ActionCable.server.broadcast "game_channel_#{@game_.id}", session["players_#{@game.id}"]
    # binding.pry
    GameChannel.broadcast(@game.id, session["players_#{@game.id}"])

    respond_to do |format|
      format.js
    end
  end

  def join
    # binding.pry
    add_player(@player)
    ## ActionCable.server.broadcast "game_channel_#{@game_.id}", session["players_#{@game.id}"]
    # GameChannel.broadcast(@game.id, session["players_#{@game.id}"])

    respond_to do |format|
      format.html { redirect_to game_path(@game, { :player => { :name => @player.name } }) }
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
      @player = Player.new(player_params)
    end

    def player_params
      params.fetch(:player, {}).permit(:name, :complexity, :amount_of_work, :unknown_risk)
    end

    def set_players_session
      session["players_#{@game.id}"] ||= []
    end
end
