class CreateGames < ActiveRecord::Migration[6.1]
  def change
    create_table :games do |t|
      t.string :name
      t.references :amount_of_work, null: false, foreign_key: true
      t.references :complexity, null: false, foreign_key: true
      t.references :unknown_risk, null: false, foreign_key: true

      t.timestamps
    end
  end
end
