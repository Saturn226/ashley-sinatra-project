class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :password_digest
      t.string :username
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :city
      t.string :state
    end
  end
end
