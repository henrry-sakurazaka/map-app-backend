class AddOauthFieldsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :provider, :string unless column_exists?(:users, :provider)
    add_column :users, :uid, :string unless column_exists?(:users, :uid)
    add_column :users, :name, :string unless column_exists?(:users, :name)
    add_column :users, :image_url, :string unless column_exists?(:users, :image_url)
    add_column :users, :access_token, :string unless column_exists?(:users, :access_token)
  end
end
