class AddCategoryIdToFeed < ActiveRecord::Migration
  def change
    add_column :feeds, :category_id, :integer
  end
end
