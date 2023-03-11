require "test_helper"

class WebhookControllerTest < ActionDispatch::IntegrationTest
  test "should get callback" do
    get webhook_callback_url
    assert_response :success
  end
end
