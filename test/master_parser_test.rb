require_relative '../test/test_helper'
require_relative '../lib/master_parser'
require_relative '../lib/file_io'

class MasterParserTest < Minitest::Test

  def setup
    @fixture_data = FileIO.get_data("./test/data/district_test_fixture.csv")
  end

  def test_it_returns_all_unique_districts
    fixture_datas = FileIO.get_data("./test/data/district_test_fixture.csv")

    assert_equal 14, MasterParser.names(fixture_datas).length
  end

  def test_it_returns_all_unique_years
    assert_equal 5, MasterParser.years(@fixture_data).length
  end

  def test_it_returns_all_unique_values
    # skip
    assert_equal 34, MasterParser.values(@fixture_data).length
  end

  def test_it_returns_related_data_for_a_single_district
    expected = {2010 => 0.436, 2011 => 0.489, 2012 => 0.479, 2013 => 0.488, 2014 => 0.490}
    assert_equal expected, MasterParser.flattened_data(@fixture_data,"Academy 20")
  end

  def test_it_prepares_list_of_file_ext_from_nested_filepaths
    nested_filepaths = {  :enrollment => {
                          :kindergarten => "./test/data/kindergarten_enrollment_sample.csv",
                          :high_school_graduation => "./test/data/high_school_grad_sample.csv"}}
    assert_equal ["./test/data/kindergarten_enrollment_sample.csv", "./test/data/high_school_grad_sample.csv"], MasterParser.files(nested_filepaths)
  end

  def test_it_creates_list_of_unique_names_from_all_files
    nested_filepaths = {  :enrollment => {
                          :kindergarten => "./test/data/kindergarten_enrollment_sample.csv",
                          :high_school_graduation => "./test/data/high_school_grad_sample.csv"}}
    expected = ["COLORADO", "ACADEMY 20", "ADAMS COUNTY 14", "ADAMS-ARAPAHOE 28J", "CHEYENNE COUNTY RE-5", "CHEYENNE MOUNTAIN 12"]

    assert_equal expected, MasterParser.all_uniq_names(nested_filepaths)
  end

  def test_it_returns_empty_array_if_no_files_given
    assert_equal [], MasterParser.all_uniq_names()
  end

  def test_it_creates_list_of_ALL_CAPS_unique_names_from_all_files
    nested_filepaths = {  :enrollment => {
                          :kindergarten => "./test/data/kindergarten_enrollment_sample.csv",
                          :high_school_graduation => "./test/data/high_school_grad_sample.csv"}}
    expected = ["COLORADO", "ACADEMY 20", "ADAMS COUNTY 14", "ADAMS-ARAPAHOE 28J", "CHEYENNE COUNTY RE-5", "CHEYENNE MOUNTAIN 12"]

    assert_equal expected, MasterParser.all_uniq_names(nested_filepaths)
  end

  def test_it_creates_list_of_names_from_just_enrollment_files
    nested_filepaths = {  :enrollment => {
                          :kindergarten => "./test/data/kindergarten_enrollment_sample.csv"},
                          :testing => {
                          :high_school_graduation => "./test/data/high_school_grad_sample.csv"}}
    expected = ["COLORADO", "ACADEMY 20", "ADAMS COUNTY 14", "ADAMS-ARAPAHOE 28J"]

    assert_equal expected, MasterParser.all_uniq_names(nested_filepaths, :enrollment)
  end

  def test_it_creates_list_of_names_from_just_testing_files
    nested_filepaths = {  :enrollment => {
                          :kindergarten => "./test/data/kindergarten_enrollment_sample.csv"},
                          :testing => {
                          :high_school_graduation => "./test/data/high_school_grad_sample.csv"}}
    expected = ["COLORADO", "ACADEMY 20", "ADAMS COUNTY 14", "ADAMS-ARAPAHOE 28J", "CHEYENNE COUNTY RE-5", "CHEYENNE MOUNTAIN 12"]

    assert_equal expected, MasterParser.all_uniq_names(nested_filepaths, :testing)
  end

end
