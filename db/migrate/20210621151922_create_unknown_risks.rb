class CreateUnknownRisks < ActiveRecord::Migration[6.1]
  def change
    create_table :unknown_risks do |t|
      t.numeric :none
      t.numeric :low
      t.numeric :some
      t.numeric :many

      t.timestamps
    end
  end
end
