class GamesPlayersController < ApplicationController
  before_action :set_game
  before_action :set_games_player, only: %i[ show edit update destroy ]

  # DELETE /games_players/1 or /games_players/1.json
  def destroy
    @games_player.destroy
    GameChannel.broadcast(@game.id, @game.games_players)
    respond_to do |format|
      format.js
      format.turbo_stream { head :no_content }
    end
  end

  private
    def set_game
      @game = Game.find(params[:game_id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_games_player
      @games_player = GamesPlayer.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def games_player_params
      params.require(:games_player).permit(:name, :complexity, :amount_of_work, :unknown_risk)
    end
end
