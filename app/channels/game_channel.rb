class GameChannel < ApplicationCable::Channel
  def subscribed
    stream_from "game_channel_#{params[:game_id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def self.broadcast(id, games_players)
    ActionCable.server.broadcast "game_channel_#{id}", html(games_players, games_players.players_all_voted?)
  end

  def self.broadcast_show_votes(id, games_players)
    ActionCable.server.broadcast "game_channel_#{id}", html(games_players, true)
  end

  def self.html(players, show_player_votes)
    ApplicationController.render(
      partial: 'games/players_table',
      locals: { players: players, :show_player_votes => show_player_votes }
    )
  end
end
