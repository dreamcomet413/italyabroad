require 'test_helper'

class FoodOptionTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert FoodOption.new.valid?
  end
end
