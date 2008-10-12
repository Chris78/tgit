require File.dirname(__FILE__) + '/../test_helper'
require 'input_controller'

# Re-raise errors caught by the controller.
class InputController; def rescue_action(e) raise e end; end

class InputControllerTest < Test::Unit::TestCase
  def setup
    @controller = InputController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
