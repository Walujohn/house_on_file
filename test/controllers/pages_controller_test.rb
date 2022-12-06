require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
#    get pages_home_url
    get root_path
    assert_response :success
  end
end
