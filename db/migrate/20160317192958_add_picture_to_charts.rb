class AddPictureToCharts < ActiveRecord::Migration
  def change
    add_column :charts, :picture, :string
  end
end
