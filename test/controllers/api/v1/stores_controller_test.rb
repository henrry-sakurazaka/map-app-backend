require "test_helper"

class Api::V1::StoresControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_v1_stores_url
    assert_response :success
  end
end
