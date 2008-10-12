require File.dirname(__FILE__) + '/../test_helper'
require 'tagging_controller'

# Re-raise errors caught by the controller.
class TaggingController; def rescue_action(e) raise e end; end

class TaggingControllerTest < Test::Unit::TestCase
  def setup
    @controller = TaggingController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
