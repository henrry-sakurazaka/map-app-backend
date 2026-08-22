

module Api
  module V1
    class StoresController < ApplicationController
      skip_before_action :authenticate_user!, only: [ :index ]

      # CSRFトークンの検証をスキップ（APIのため）
      # skip_before_action :verify_authenticity_token

      def index
        stores = ::Store.all.includes(:reviews)

        render json: stores.as_json(include: :reviews)
      rescue StandardError => e
        Rails.logger.error "Stores Index Error: #{e.message}"
        render json: [], status: :internal_server_error
      end
    end
  end
end
