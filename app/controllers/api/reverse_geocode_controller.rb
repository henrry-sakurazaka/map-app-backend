# app/controllers/api/reverse_geocode_controller.rb
require 'net/http'
require 'json'

class Api::ReverseGeocodeController < ApplicationController
  def index
    lat = params[:lat]
    lon = params[:lon]

    if lat.blank? || lon.blank?
      render json: { error: "Missing lat/lon parameters" }, status: :bad_request and return
    end

    # Nominatim API に問い合わせ
    url = URI("https://nominatim.openstreetmap.org/reverse?lat=#{lat}&lon=#{lon}&format=json&accept-language=ja")
    response = Net::HTTP.get_response(url)

    if response.is_a?(Net::HTTPSuccess)
      data = JSON.parse(response.body)
      render json: data
    else
      render json: { error: "Reverse geocoding failed" }, status: :bad_request
    end
  end
end
