require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'

require_relative '../lib/parser.rb'

class ParserTest < Minitest::Test

  def test_it_returns_a_district
    parsed = Parser.new('./test/data/kindergarten_enrollment_sample.csv')

    assert_equal "Colorado", parsed.district
  end

  def test_it_returns_a_year
    parsed = Parser.new('./test/data/kindergarten_enrollment_sample.csv')

    assert_equal "2007", parsed.year
  end

  def test_it_returns_a_percentage
    parsed = Parser.new('./test/data/kindergarten_enrollment_sample.csv')

    assert_equal "0.39465", parsed.percentage
  end

  def test_it_return_a_district_in_row_15
    parsed = Parser.new('./test/data/kindergarten_enrollment_sample.csv')



  end

  # def test_it_returns_the_percentage_for_a_given_year_and_district
  #   parsed = Parser.new('./test/data/kindergarten_enrollment_sample.csv')
  #
  #   assert_equal "0.67331", parsed.find("ADAMS COUNTY 14",2008)
  # end


end