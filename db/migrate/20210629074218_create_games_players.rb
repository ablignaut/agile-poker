class CreateGamesPlayers < ActiveRecord::Migration[6.1]
  def change
    create_table :games_players do |t|
      t.string :name
      t.belongs_to :game, null: false, foreign_key: true
      t.numeric :complexity
      t.numeric :amount_of_work
      t.numeric :unknown_risk

      t.timestamps
    end
  end
end
