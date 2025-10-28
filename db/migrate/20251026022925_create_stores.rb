class CreateStores < ActiveRecord::Migration[8.0]
  def change
    create_table :stores do |t|
      t.string :name
      t.text :description
      t.float :latitude
      t.float :longitude
      t.string :address
      t.string :phone_number

      t.timestamps
    end
  end
end
