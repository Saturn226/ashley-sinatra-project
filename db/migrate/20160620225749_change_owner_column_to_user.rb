class ChangeOwnerColumnToUser < ActiveRecord::Migration
  def change
    rename_column :pets, :owner_id, :user_id
  end
end
