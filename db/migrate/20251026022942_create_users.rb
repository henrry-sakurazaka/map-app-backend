class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :provider
      t.string :uid
      t.string :name
      t.string :email
      t.string :image_url
      t.string :access_token
      t.string :password_digest
      t.timestamps
    end
  end
end
