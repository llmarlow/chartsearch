class AddIsMagazineToCharts < ActiveRecord::Migration
  def change
    add_column :charts, :is_magazine, :boolean
  end
end
