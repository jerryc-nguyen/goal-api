class AddCounterCacheMissing < ActiveRecord::Migration
  def change
    add_column :goals, :likes_count, :integer, default: 0
    add_column :goals, :comments_count, :integer, default: 0

    add_column :comments, :likes_count, :integer, default: 0
  end
end
