require 'test_helper'

class DesiredExpenditureTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert DesiredExpenditure.new.valid?
  end
end
