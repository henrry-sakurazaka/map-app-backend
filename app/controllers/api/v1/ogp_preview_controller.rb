require "open-uri"

class Api::V1::OgpPreviewController < ApplicationController
    skip_before_action :authenticate_user!

  # def show
  #     url = params[:url]

  #     html =  URI.open(url, "User-Agent" => "Mozilla/5.0").read
  #     doc = Nokogiri::HTML(html)

  #     render json: {
  #         title: doc.at('meta[property="og:title"]')&.[]("content"),
  #         description: doc.at('meta[property="og:description"]')&.("content"),
  #         image: doc.at('meta[property="og:image"]')&.[]("content"),
  #         url: url
  #     }
  # end
  def show
      render json: {
          title: "test",
          description: "OGPtest",
          image: "",
          url: params[:url]
      }
  end
end
