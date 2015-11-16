require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'

require_relative '../lib/parser.rb'

class ParserTest < Minitest::Test

  def setup_data_to_be_parsed
    skip
  end

  def test_it_pulls_out_correct_data_for_enrollment_instances
    skip
    @filepath = {:enrollment => {
                 :kindergarten => "./test/data/district_test_fixture.csv"}}
    @parser = Parser.new
    @parser.read_file(@filepath)

    expected = {:name=>"ACADEMY 20", :kindergarten_participation=>{2010=>0.436, 2011=>0.489, 2012=>0.479, 2013=>0.488, 2014=>0.49}}

    assert_equal expected, @parser.all_data("Academy 20")
  end

  def test_it_initiates_with_a_hash_of_label_handle_pairs
    skip
   parser = Parser.new({:kindergarten => "./test/data/district_test_fixture.csv"})
  #  expected = {:name=>"COLORADO",
  #          :kindergarten_participation=>{
  #            2007=>0.39465, 2006=>0.33677,
  #            2005=>0.27807, 2004=>0.24014,
  #            2008=>0.5357, 2009=>0.598,
  #            2010=>0.64019, 2011=>0.672,
  #            2012=>0.695, 2013=>0.70263,
  #            2014=>0.74118},
  #          :high_school_graduation=>{
  #            2010 => 0.895,
  #            2011 => 0.895,
  #            2012 => 0.889,
  #            2013 => 0.913,
  #            2014 => 0.898,
  #            }}
  #  assert_equal expected, parser.all_data("Academy 20")

  assert Hash, @label_handle_hash.class
  assert Symbol, @label_handle_hash.keys[0].class
  assert CSV, @label_handle_hash.values[0].class
  end

end
