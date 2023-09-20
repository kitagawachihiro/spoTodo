require 'test_helper'

class LineEventsControllerTest < ActionDispatch::IntegrationTest
  test 'should get client' do
    get line_events_client_url
    assert_response :success
  end

  test 'should get recieve' do
    get line_events_recieve_url
    assert_response :success
  end

end
