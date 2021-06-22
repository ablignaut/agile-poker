class GameChannel < ApplicationCable::Channel
  def subscribed
    stream_from "game_channel_#{params[:game_id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def self.broadcast(id, data)
    ActionCable.server.broadcast "game_channel_#{id}", html(data)
  end

  def self.html(players)
    ApplicationController.render(
      partial: 'games/players_table',
      locals: { players: players }
    )
  end
end
