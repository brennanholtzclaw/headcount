require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'

require_relative '../lib/enrollment'

class EnrollmentTest < Minitest::Test
  attr_reader :data, :e

  def instantiate_enrollment_with_data
    @data = {:name=>"COLORADO",
            :kindergarten_participation=>{
              "2007"=>"0.39465", "2006"=>"0.33677",
              "2005"=>"0.27807", "2004"=>"0.24014",
              "2008"=>"0.5357", "2009"=>"0.598",
              "2010"=>"0.64019", "2011"=>"0.672",
              "2012"=>"0.695", "2013"=>"0.70263",
              "2014"=>"0.74118"}}
    @e = Enrollment.new(data)
  end

  def test_it_is_initialized_with_data
    instantiate_enrollment_with_data

    assert_equal data, e.data
  end

  def test_returns_kindergarten_participation_by_year
    instantiate_enrollment_with_data

    assert_equal data[:kindergarten_participation], e.kindergarten_participation_by_year
  end

  def test_returns_kindergarten_participation_in_year
    instantiate_enrollment_with_data

    assert_equal "0.24014", e.kindergarten_participation_in_year("2004")
  end

  def test_returns_nil_if_no_data_included
    instantiate_enrollment_with_data

    assert_nil e.kindergarten_participation_in_year("1998")
  end

end
