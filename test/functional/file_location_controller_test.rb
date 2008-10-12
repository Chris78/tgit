require File.dirname(__FILE__) + '/../test_helper'
require 'file_location_controller'

# Re-raise errors caught by the controller.
class FileLocationController; def rescue_action(e) raise e end; end

class FileLocationControllerTest < Test::Unit::TestCase
  def setup
    @controller = FileLocationController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
