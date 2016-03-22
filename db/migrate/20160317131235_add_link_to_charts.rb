class AddLinkToCharts < ActiveRecord::Migration
  def change
    add_column :charts, :link, :string
  end
end
