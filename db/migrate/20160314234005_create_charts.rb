class CreateCharts < ActiveRecord::Migration
  def change
    create_table :charts do |t|
      t.string :name
      t.integer :height
      t.integer :width
      t.decimal :price

      t.timestamps null: false
    end
  end
end
