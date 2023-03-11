class CreateOuts < ActiveRecord::Migration[7.0]
  def change
    create_table :outs do |t|
      t.boolean :went_out
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
