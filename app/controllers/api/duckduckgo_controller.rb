require "net/http"
require "uri"
require "json"

module Api
  class Api::DuckduckgoController < ApplicationController
    def show
      query = params[:q]
      return render json: { error: "missing query" }, status: 400 if query.blank?

      uri = URI("https://api.duckduckgo.com/?q=#{URI.encode_www_form_component(query)}&format=json")
      res = Net::HTTP.get_response(uri)

      if res.is_a?(Net::HTTPSuccess)
        render json: JSON.parse(res.body)
      else
        render json: { error: "DuckDuckGo API error" }, status: :bad_request
      end
    rescue => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end
end
