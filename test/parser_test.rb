require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'

require_relative '../lib/parser.rb'

class ParserTest < Minitest::Test

  def test_it_pulls_out_correct_data_for_enrollment_instances
    skip
    @filepath = {:enrollment => {
                 :kindergarten => "./test/data/district_test_fixture.csv"}}
    @parser = Parser.new
    expected = {:name=>"ACADEMY 20", :kindergarten_participation=>{2010=>0.436, 2011=>0.489, 2012=>0.479, 2013=>0.488, 2014=>0.49}}

    assert_equal expected, @parser.find_district_data_in_mult_files("Academy 20", @filepath)
  end

  def test_it_initiates_with_a_hash_of_label_handle_pairs
    skip
    parser = Parser.new({:enrollment => {:kindergarten => "./test/data/district_test_fixture.csv"}})
    parser.read_file({:kindergarten => "./test/data/district_test_fixture.csv"})

    assert_equal Hash, parser.label_handle_hash.class
    assert_equal Symbol, parser.label_handle_hash.keys[0].class
    assert_equal String, parser.label_handle_hash.values[0].class
  end

  def test_it_reads_file_and_returns_one_districts_data_for_one_file
    parser = Parser.new
    district = "Academy 20"
    label = :kindergarten_data
    filepath = "./test/data/district_test_fixture.csv"
    expected = {"academy 20"=>{:kindergarten_data=>{2010=>0.436, 2011=>0.489, 2012=>0.479, 2013=>0.488, 2014=>0.49}}}

    assert_equal expected, parser.reads_file_and_returns_1_districts_data_for_one_file(district,label, filepath)
  end

  def test_it_reads_file_and_returns_one_districts_data_for_multiple_files
    parser = Parser.new
    district = "Academy 20"
    filepath = {:enrollment => {
                :kindergarten => "./test/data/district_test_fixture.csv",
                :high_school_graduation => "./test/data/high_school_grad_sample.csv"}}
    expected = {"academy 20"=>{:kindergarten=>{2010=>0.436, 2011=>0.489, 2012=>0.479, 2013=>0.488, 2014=>0.49}, :high_school_graduation=>{2010=>0.895, 2011=>0.895, 2012=>0.89, 2013=>0.914, 2014=>0.898}}}

    assert_equal expected, parser.find_district_data_in_mult_files(district,filepath)
  end

  def test_multiple_file_reader_doesnt_break_if_only_one_file_given
    parser = Parser.new
    district = "Academy 20"
    filepath = {:enrollment => {
                :kindergarten => "./test/data/district_test_fixture.csv"}}
    expected = {"academy 20"=>{:kindergarten=>{2010=>0.436, 2011=>0.489, 2012=>0.479, 2013=>0.488, 2014=>0.49}}}

    assert_equal expected, parser.find_district_data_in_mult_files(district,filepath)
  end
end
