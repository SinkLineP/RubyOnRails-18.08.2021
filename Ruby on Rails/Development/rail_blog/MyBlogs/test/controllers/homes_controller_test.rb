require 'test_helper'

class HomesControllerTest < ActionDispatch::IntegrationTest
  test "should get contacts" do
    get homes_contacts_url
    assert_response :success
  end

end
