class AddOauthFieldsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :provider, :string
    add_column :users, :uid, :string
    add_column :users, :name, :string
    add_column :users, :image_url, :string
    add_column :users, :access_token, :string
  end
end
