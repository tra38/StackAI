class AddAuthorProfileToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :author_profile, :string
  end
end
