class CreateAmountOfWorks < ActiveRecord::Migration[6.1]
  def change
    create_table :amount_of_works do |t|
      t.numeric :tiny
      t.numeric :little
      t.numeric :fair
      t.numeric :large
      t.numeric :huge

      t.timestamps
    end
  end
end
