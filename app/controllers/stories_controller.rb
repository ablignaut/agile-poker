class StoriesController < ApplicationController
  before_action :set_game
  before_action :set_story, only: [:destroy, :update, :accept_estimate, :activate]

  def create
    @story = @game.stories.build(story_params)
    @story.position = @game.stories.maximum(:position).to_i + 1

    if @story.save
      GameChannel.broadcast_stories(@game)
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to game_path(@game) }
      end
    else
      respond_to do |format|
        format.turbo_stream { render :create }
        format.html { redirect_to game_path(@game), alert: @story.errors.full_messages.join(", ") }
      end
    end
  end

  def destroy
    @story.destroy
    @game.stories.ordered.each_with_index { |s, i| s.update_column(:position, i) }
    GameChannel.broadcast_stories(@game)
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to game_path(@game) }
    end
  end

  def update
    if @story.update(story_params)
      GameChannel.broadcast_stories(@game)
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to game_path(@game) }
      end
    else
      respond_to do |format|
        format.html { redirect_to game_path(@game), alert: @story.errors.full_messages.join(", ") }
      end
    end
  end

  def accept_estimate
    players_voted = @game.games_players.players_voted
    @story.update!(status: 'estimated', estimate: compute_estimate(players_voted))

    @game.games_players.update_all(complexity: nil, amount_of_work: nil, unknown_risk: nil)

    next_story = @game.stories.pending.first
    next_story&.update!(status: 'active')

    GameChannel.broadcast(@game.id, @game.games_players)
    GameChannel.broadcast_stories(@game)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to game_path(@game) }
    end
  end

  def activate
    @game.stories.active.where.not(id: @story.id).update_all(status: 'pending')
    @story.update!(status: 'active')

    @game.games_players.update_all(complexity: nil, amount_of_work: nil, unknown_risk: nil)

    GameChannel.broadcast(@game.id, @game.games_players)
    GameChannel.broadcast_stories(@game)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to game_path(@game) }
    end
  end

  private

  def set_game
    @game = Game.find(params[:game_id])
  end

  def set_story
    @story = @game.stories.find(params[:id])
  end

  def story_params
    params.require(:story).permit(:title, :description, :url, :position)
  end

  def compute_estimate(players_voted)
    return nil if players_voted.blank?
    avg = players_voted.sum(&:fibonacci_vote).to_d / players_voted.count
    GamesPlayer::FIB_ARRAY.min_by { |f| (f - avg).abs }
  end
end
