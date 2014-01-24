require 'test_helper'

class Site::AuthenticationTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Site::Authentication.new.valid?
  end
end
