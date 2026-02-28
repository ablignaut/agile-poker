class AddObserverToGamesPlayers < ActiveRecord::Migration[8.1]
  def change
    add_column :games_players, :observer, :boolean, null: false, default: false
  end
end
