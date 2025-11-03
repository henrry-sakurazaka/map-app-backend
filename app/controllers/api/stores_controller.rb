# app/controllers/api/v1/stores_controller.rb
class Api::V1::StoresController < ApplicationController
  def index
    stores = [
      {
        id: 1,
        name: "サンプルカフェ",
        address: "東京都千代田区丸の内1-1-1",
        website: "https://example.com/cafe",
        ogp: {
          title: "サンプルカフェ - おしゃれなカフェ",
          description: "丸の内の人気カフェ。コーヒーとスイーツが美味しい！",
          image: "https://placehold.jp/150x150.png",
          url: "https://example.com/cafe"
        }
      },
      {
        id: 2,
        name: "サンプルレストラン",
        address: "東京都中央区銀座1-1-1",
        website: "https://example.com/restaurant",
        ogp: {
          title: "サンプルレストラン - 美味しいランチ",
          description: "銀座でランチならここ。シェフおすすめのメニューが豊富。",
          image: "https://placehold.jp/150x150.png",
          url: "https://example.com/restaurant"
        }
      }
    ]

    render json: stores
  end
end
