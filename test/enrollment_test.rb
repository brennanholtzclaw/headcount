require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'

require_relative '../lib/enrollment'

class EnrollmentTest < Minitest::Test

  def test_returns_percentage_for_all_years_in_data

  end

  def test_returns_kindergarten_participation_by_year
    ##returns nil if given unknown year
    ##returns floatnum for percentage
  end

end
