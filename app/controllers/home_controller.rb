class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :index ]

  def index
    render file: Rails.root.join("public/index.html"), layout: false
  end
end
