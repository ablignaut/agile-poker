class CreateComplexities < ActiveRecord::Migration[6.1]
  def change
    create_table :complexities do |t|
      t.numeric :none
      t.numeric :little
      t.numeric :fair
      t.numeric :complex
      t.numeric :very_complex

      t.timestamps
    end
  end
end
