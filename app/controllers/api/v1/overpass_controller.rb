
class Api::V1::OverpassController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    lat = Float(params[:lat])
    lon = Float(params[:lon])
    radius = Integer(params[:radius] || 500)

    unless lat.between?(-90, 90) &&
           lon.between?(-180, 180) &&
           radius.between?(1, 5000)
      render json: {
        elements: [],
        error: "Invalid search parameters."
      }, status: :bad_request
      return
    end

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
      "https://overpass-api.de/api/interpreter"
    ]

    urls.each do |url|
      max_attempts = 3

      (1..max_attempts).each do |attempt|
        begin
          response = HTTParty.post(
            url,
            body: { data: query },
            headers: {
              "Content-Type" => "application/x-www-form-urlencoded",
              "User-Agent" => "ShopMap/1.0 (contact: #{ENV['EMAIL']})",
              "Accept" => "application/json"
            },
            timeout: 20
          )

        rescue StandardError => e
          Rails.logger.warn(
            "Overpass connection failed: " \
            "url=#{url}, #{e.class}: #{e.message}"
          )
          break
        end

        if response.success?
          begin
            result = JSON.parse(response.body)

            Rails.logger.info("Overpass成功: #{url}")

            render json: result
            return

          rescue JSON::ParserError => e
            Rails.logger.error(
              "Overpass JSON parse failed: #{url} #{e.message}"
            )
            break
          end
        end

        Rails.logger.warn(
          "Overpass API failed: " \
          "status=#{response.code}, " \
          "url=#{url}, " \
          "attempt=#{attempt}, " \
          "body=#{response.body.to_s.first(500)}"
        )

        if [429, 502, 503, 504].include?(response.code.to_i) &&
           attempt < max_attempts

          wait_time = 2**(attempt - 1)

          Rails.logger.info(
            "Overpass retry: #{wait_time} seconds"
          )

          sleep(wait_time)
          next
        end

        break
      end
    end

    Rails.logger.error(
      "All Overpass API endpoints are unavailable."
    )

    render json: {
      elements: [],
      error: "Overpass API is unavailable. Please try again later."
    }, status: :service_unavailable

  rescue ArgumentError, TypeError
    render json: {
      elements: [],
      error: "Invalid search parameters."
    }, status: :bad_request
  end
end


# class Api::V1::OverpassController < ApplicationController
#   skip_before_action :authenticate_user!

#   def index
#     lat = params[:lat]
#     lon = params[:lon]
#     radius = params[:radius] || 500

#     query = <<~QUERY
#       [out:json][timeout:15];
#       (
#         node["shop"](around:#{radius},#{lat},#{lon});
#         node["amenity"~"cafe|restaurant|bar|fast_food"](around:#{radius},#{lat},#{lon});
#       );
#       out center;
#     QUERY

#     urls = [
#       "https://overpass.kumi.systems/api/interpreter",
#       "https://overpass-api.de/api/interpreter",
#       "https://overpass.nchc.org.tw/api/interpreter"
#     ]

#     urls.each do |url|
#       begin
#         response = HTTParty.post(
#           url,
#           body: query,
#           headers: {
#             "Content-Type" => "text/plain",
#             "User-Agent" => "ShopMap/1.0 (contact: #{ENV['EMAIL']})",
#             "Accept" => "application/json"
#           },
#           timeout: 20
#         )

#         if response.success?
#           Rails.logger.info("✅ Overpass成功: #{url}")

#           render json: JSON.parse(response.body)
#           return
#         end

#        Rails.logger.warn(
#           "❌ Overpass API failed: " \
#           "status=#{response.code}, " \
#           "url=#{url}, " \
#           "body=#{response.body.to_s.first(500)}"
#         )

#       rescue StandardError => e
#         Rails.logger.warn(
#           "❌ Overpass connection failed: #{url} #{e.message}"
#         )
#       end
#     end

#     # すべてのOverpass APIが失敗した場合
#     Rails.logger.error("❌ すべてのOverpass APIが利用できません。混雑が予想されます。")

#     render json: {
#       elements: [],
#       error: "overpass API is unavailable. Please try again later."
#     }, status: :service_unavailable
#   end
# end
