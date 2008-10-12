require File.dirname(__FILE__) + '/../test_helper'
require 'random_tag_controller'

# Re-raise errors caught by the controller.
class RandomTagController; def rescue_action(e) raise e end; end

class RandomTagControllerTest < Test::Unit::TestCase
  def setup
    @controller = RandomTagController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
