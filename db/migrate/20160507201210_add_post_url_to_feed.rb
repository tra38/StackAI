class AddPostUrlToFeed < ActiveRecord::Migration
  def change
    add_column :feeds, :post_url, :string
  end
end
