class ChangeCommentsToComment < ActiveRecord::Migration[7.0]
  def change
    rename_column :comments, :comments, :comment
  end
end
