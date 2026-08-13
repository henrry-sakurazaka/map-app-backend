class Api::V1::OverpassController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    lat = params[:lat]
    lon = params[:lon]
    radius = params[:radius] || 500

    query = <<~QUERY
      [out:json][timeout:15];
      (
        node["shop"](around:#{radius},#{lat},#{lon});
        node["amenity"~"cafe|restaurant|bar|fast_food"](around:#{radius},#{lat},#{lon});
      );
      out center;
    QUERY

    urls = [
      "https://overpass.kumi.systems/api/interpreter",
      "https://overpass-api.de/api/interpreter",
      "https://overpass.nchc.org.tw/api/interpreter"
    ]

    urls.each do |url|
      begin
        response = HTTParty.post(
          url,
          body: query,
          headers: {
            "Content-Type" => "text/plain"
          },
          timeout: 20
        )

        if response.success?
          Rails.logger.info("✅ Overpass成功: #{url}")

          render json: JSON.parse(response.body)
          return
        end

        Rails.logger.warn(
          "❌ Overpass API failed: #{response.code} #{url}"
        )

      rescue StandardError => e
        Rails.logger.warn(
          "❌ Overpass connection failed: #{url} #{e.message}"
        )
      end
    end

    # すべてのOverpass APIが失敗した場合
    Rails.logger.error("❌ すべてのOverpass APIが利用できません")

    render json: {
      elements: []
    }, status: :ok
  end
end
