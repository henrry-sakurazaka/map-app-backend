# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# db/seeds.rb

# 既存のデータを削除することで、seedsを繰り返し実行してもデータが重複しないようにする
puts "Cleaning up database..."
Review.destroy_all
Store.destroy_all
User.destroy_all
puts "Database cleaned!"

puts "Creating Users..."
# ユーザーを作成（レビュー投稿に必要）
user1 = User.create!(email: 'alice@example.com', password: 'password', password_confirmation: 'password')
user2 = User.create!(email: 'bob@example.com', password: 'password', password_confirmation: 'password')
puts "Users created: #{User.count}"

puts "Creating Stores..."
# 1. 緯度・経度を含む店舗データを作成
store1 = Store.create!(
  name: "レトロ喫茶 モカ",
  description: "昔ながらの落ち着いた雰囲気の喫茶店。絶品オムライスが人気。",
  # 例: 緯度経度は東京駅周辺の適当な値を設定
  latitude: 35.681236,
  longitude: 139.767125,
  address: "東京都千代田区",
  phone_number: "03-xxxx-xxxx"
)

store2 = Store.create!(
  name: "地中海バル オリーブ",
  description: "新鮮な魚介とワインが楽しめる地中海料理のバル。テラス席あり。",
  # 例: 上記から少し離れた地点
  latitude: 35.685000,
  longitude: 139.760000,
  address: "東京都千代田区丸の内",
  phone_number: "03-yyyy-yyyy"
)

puts "Stores created: #{Store.count}"

puts "Creating Reviews..."
# 2. 口コミデータを作成し、作成したユーザーと店舗に関連付ける
Review.create!(
  store: store1,
  user: user1,
  rating: 5,
  content: "オムライスが最高でした！店主の方も親切でまた来ます。"
)

Review.create!(
  store: store2,
  user: user2,
  rating: 4,
  content: "パエリアが美味しかったですが、少し賑やかすぎました。"
)
puts "Reviews created: #{Review.count}"

puts "Seeding complete!"