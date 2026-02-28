class GameChannel < ApplicationCable::Channel
  def subscribed
    stream_from "game_channel_#{params[:game_id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def self.broadcast(id, games_players)
    ActionCable.server.broadcast "game_channel_#{id}", {
      type: 'players',
      html: html(games_players, games_players.players_all_voted?)
    }
  end

  def self.broadcast_show_votes(id, games_players)
    ActionCable.server.broadcast "game_channel_#{id}", {
      type: 'players',
      html: html(games_players, true)
    }
  end

  def self.broadcast_stories(game)
    ActionCable.server.broadcast "game_channel_#{game.id}", {
      type: 'stories',
      html: stories_html(game)
    }
  end

  def self.html(players, show_player_votes)
    ApplicationController.render(
      partial: 'games/players_table',
      locals: { players: players, :show_player_votes => show_player_votes }
    )
  end

  def self.stories_html(game)
    ApplicationController.render(
      partial: 'games/stories_panel',
      locals: { game: game, stories: game.stories.ordered }
    )
  end
end
