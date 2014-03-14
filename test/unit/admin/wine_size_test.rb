require 'test_helper'

class Admin::WineSizeTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Admin::WineSize.new.valid?
  end
end
