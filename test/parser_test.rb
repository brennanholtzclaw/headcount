require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'

require_relative '../lib/parser.rb'

class ParserTest < Minitest::Test

  def setup_data_to_be_parsed
    skip
  end

  def test_it_pulls_out_correct_data_for_enrollment_instances
    @filepath = {:enrollment => {
                 :kindergarten => "./test/data/district_test_fixture.csv"}}
    @parser = Parser.new
    @parser.read_file(@filepath)

    expected = {:name=>"ACADEMY 20", :kindergarten_participation=>{2010=>0.436, 2011=>0.489, 2012=>0.479, 2013=>0.488, 2014=>0.49}}

    assert_equal expected, @parser.all_data("Academy 20")
  end

end
