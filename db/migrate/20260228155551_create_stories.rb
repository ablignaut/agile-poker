class CreateStories < ActiveRecord::Migration[8.1]
  def change
    create_table :stories do |t|
      t.references :game, null: false, foreign_key: true
      t.string     :title,       null: false
      t.text       :description
      t.string     :url
      t.decimal    :estimate
      t.integer    :position,    null: false, default: 0
      t.string     :status,      null: false, default: 'pending'

      t.timestamps
    end

    add_index :stories, [:game_id, :position]
    add_index :stories, [:game_id, :status]
  end
end
