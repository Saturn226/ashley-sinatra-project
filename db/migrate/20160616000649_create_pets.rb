class CreatePets < ActiveRecord::Migration
  def change
    create_table :pets do |t|
      t.string :name
      t.string :breed
      t.string :bio
      t.string :price
      t.boolean :adoptable
    end
  end
end
