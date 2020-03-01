require 'test_helper'

class ControlControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get control_index_url
    assert_response :success
  end

end
