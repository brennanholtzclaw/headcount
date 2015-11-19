require_relative 'test_helper'
require_relative '../lib/parser.rb'

class ParserTest < Minitest::Test

  def test_it_pulls_out_correct_data_for_enrollment_instances
    @filepath = {:enrollment => {
                 :kindergarten => "./test/data/district_test_fixture.csv"}}
    @parser = Parser.new
    expected = {"academy 20"=>{:kindergarten=>{2010=>0.436, 2011=>0.489, 2012=>0.479, 2013=>0.488, 2014=>0.49}}}

    assert_equal expected, @parser.find_district_data_in_mult_files("Academy 20", @filepath)
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
