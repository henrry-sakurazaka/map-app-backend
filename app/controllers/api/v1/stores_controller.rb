class Api::V1::StoresController < ApplicationController
  def index
  end
end

module Api
  module V1
    class StoresController < ApplicationController
      # CSRFトークンの検証をスキップ（APIのため）
      # skip_before_action :verify_authenticity_token

      def index
        # データベースからデータを取得
        # includes(:reviews) は、関連するレビューも効率的に取得するための記述
        stores = ::Store.all.includes(:reviews)

        # 【最重要】取得したデータを強制的にJSON形式で返す
        render json: stores.to_json
      rescue StandardError => e
        # エラーが発生した場合、ログに出力し、空のJSON配列を返す
        Rails.logger.error "Stores Index Error: #{e.message}"
        render json: [].to_json, status: :internal_server_error
      end
    end
  end
end
