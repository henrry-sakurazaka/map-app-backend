require 'rails_helper'

RSpec.describe "Users API", type: :request do
  describe "POST /api/v1/auth/register" do
    it "ユーザーが正常に作成される" do
      expect {
        post "/api/v1/auth/register", params: {
          email: "test@example.com",
          password: "password123"
        }
      }.to change(User, :count).by(1)

      expect(response).to have_http_status(:created)

      json = JSON.parse(response.body)
      expect(json["user"]["email"]).to eq("test@example.com")
    end
  end

    it "emailがないと失敗する" do
    post "/api/v1/auth/register", params: {
      email: "",
      password: "password123"
    }

    expect(response).to have_http_status(:unprocessable_entity)
  end

  describe "POST /api/v1/auth/login" do
    it "正しい資格情報でログインできる" do
      user = User.create!(
        email: "test@example.com",
        password: "password123",
        name: "test"
      )

      post "/api/v1/auth/login", params: {
        email: "test@example.com",
        password: "password123"
      }

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json["user"]["email"]).to eq("test@example.com")
      expect(json["token"]).to be_present
    end

    it "パスワードが違うとログインできない" do
      User.create!(
        email: "test@example.com",
        password: "password123",
      )

      post "/api/v1/auth/login", params: {
        email: "test@example.com",
        password: "wrongpassword"
      }

      expect(response).to have_http_status(:unauthorized)
    end
  end

  it "トークンでcurrent_userが取得できる" do
    user = User.create!(
      email: "test@example.com",
      password: "password123",
      name: "test"
    )

    # ログインしてトークン取得
    post "/api/v1/auth/login", params: {
      email: "test@example.com",
      password: "password123"
    }
    token = JSON.parse(response.body)["token"]

    get "/api/v1/auth/current_user", headers: {
      "Authorization" => "Bearer #{token}"
    }

    expect(response).to have_http_status(:ok)
    json = JSON.parse(response.body)
    expect(json["email"]).to eq("test@example.com")
  end

  it "トークンなしだとcurrent_userは空" do
    get "/api/v1/auth/current_user"

    expect(response).to have_http_status(:ok)
    json = JSON.parse(response.body)
    expect(json).to eq({})
  end


  describe "GET /api/v1/stores" do
    it "店舗一覧が取得できる" do
      Store.destroy_all
      Store.create!(name: "Test Store")

      get "/api/v1/stores"

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      names = json.map { |s| s["name"] }
      expect(names).to include("Test Store")
    end

    it "レビューを含めて取得できる" do
      Store.destroy_all
      User.destroy_all

      user = User.create!(
        email: "test@example.com",
        password: "password123",
        name: "test"
      )

      store = Store.create!(name: "Test Store")

      store.reviews.create!(
        content: "Good!",
        user: user
      )

      get "/api/v1/stores"

      json = JSON.parse(response.body)

      # Test Storeを探す
      target = json.find { |s| s["name"] == "Test Store" }

      expect(target["reviews"].length).to eq(1)
      expect(target["reviews"][0]["content"]).to eq("Good!")
    end
  end

  describe "GET /auth/line/callback" do
    before do
      OmniAuth.config.mock_auth[:line] = OmniAuth::AuthHash.new({
        provider: "line",
        uid: "abc123",
        info: {
          name: "Line User",
          email: nil,
          image: "http://line.image"
        }
      })

      Rails.application.env_config["omniauth.auth"] =
        OmniAuth.config.mock_auth[:line]
    end

    it "LINE認証でユーザー作成＆リダイレクトされる" do
      get "/auth/line/callback"

      expect(response).to have_http_status(:found)

      user = User.last
      expect(user.provider).to eq("line")
      expect(user.uid).to eq("abc123")

      # emailはfallbackされる
      expect(user.email).to match(/no_email_/)

      expect(response.location).to include("/oauth-callback?token=")
    end
  end


  describe "GET /auth/google_oauth2/callback" do
    before do
      OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
        provider: "google_oauth2",
        uid: "12345",
        info: {
          name: "Google User",
          email: "google@example.com",
          image: "http://image.url"
        }
      })

      Rails.application.env_config["omniauth.auth"] =
        OmniAuth.config.mock_auth[:google_oauth2]
    end

    it "Google認証でユーザー作成＆リダイレクトされる" do
      get "/auth/google_oauth2/callback"

      expect(response).to have_http_status(:found)

      user = User.last
      expect(user.provider).to eq("google_oauth2")
      expect(user.uid).to eq("12345")
      expect(user.email).to eq("google@example.com")

      expect(response.location).to include("/oauth-callback?token=")
    end
  end
end
