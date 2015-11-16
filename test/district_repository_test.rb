require 'minitest/autorun'
require 'minitest/pride'
require './lib/district_repository'
require 'csv'


class DistrictRepositoryTest < Minitest::Test
  attr_reader :dr

  def create_and_load_district_repository
    @dr = DistrictRepository.new
    @dr.load_data({:enrollment => {
                   :kindergarten => "./test/data/district_test_fixture.csv"}})
  end

  def test_it_can_load_data
    create_and_load_district_repository

    assert dr.district_repo
  end

  def test_load_data_creates_hash_for_listed_districts
    create_and_load_district_repository

    assert dr.district_repo.length > 2
    assert_equal 14, dr.district_repo.length
  end

  def test_it_can_find_by_a_full_unique_name
    create_and_load_district_repository

    assert_equal "#<District:", dr.find_by_name("ACADEMY 20").to_s[0,11]
  end

  def test_it_can_find_by_a_full_unique_downcased_name
    create_and_load_district_repository

    assert_equal "#<District:", dr.find_by_name("academy 20").to_s[0,11]
  end

  def test_find_by_name_returns_nil_if_no_match
    create_and_load_district_repository

    assert_equal nil, dr.find_by_name("zzz")
  end

  def test_find_all_matching_returns_empty_for_no_possible_match
    create_and_load_district_repository

    assert_equal [], dr.find_all_matching("zzz")
  end

  def test_find_all_matching_returns_array_for_single_possible_match
    create_and_load_district_repository

    assert_equal ["ACADEMY 20"], dr.find_all_matching("academy 20")
  end

  def test_find_all_matching_returns_two_element_array_for_double_possible_match
    create_and_load_district_repository

    assert_equal ["CHEYENNE COUNTY RE-5", "CHEYENNE MOUNTAIN 12"], dr.find_all_matching("CHEYENNE")
  end

  def test_find_all_lists_empty_array_if_no_districts_found
    dr = DistrictRepository.new

    assert_equal [], dr.find_all
  end

  def test_find_all_lists_array_of_unique_districts
    create_and_load_district_repository

    expectation = ["COLORADO", "ACADEMY 20", "ADAMS COUNTY 14", "BIG SANDY 100J", "CHERAW 31", "CHEYENNE COUNTY RE-5", "CHEYENNE MOUNTAIN 12", "CLEAR CREEK RE-1", "COLORADO SPRINGS 11", "COTOPAXI RE-3", "CREEDE CONSOLIDATED 1", "CRIPPLE CREEK-VICTOR RE-1", "CROWLEY COUNTY RE-1-J", "CUSTER COUNTY SCHOOL DISTRICT C-1"]

    assert_equal expectation, dr.find_all
    assert_equal 14, dr.find_all.count
  end

  def test_it_creates_an_enrollment_repo_when_using_load_data
    create_and_load_district_repository

    assert dr.er.enrollments.length > 5
  end

  def test_it_adds_new_instances
    dr_test = DistrictRepository.new
    dr_test.add_new_instance("COLORADO")
    dr_test.add_new_instance("A")
    dr_test.add_new_instance("B")
    dr_test.add_new_instance("C")

    assert_equal 4, dr_test.district_repo.length
    assert_equal "#<District:", dr_test.district_repo["COLORADO"].to_s[0,11]
    assert_equal "#<District:", dr_test.district_repo["A"].to_s[0,11]
    assert_equal "#<District:", dr_test.district_repo["B"].to_s[0,11]
    assert_equal "#<District:", dr_test.district_repo["C"].to_s[0,11]
  end

  def test_it_instantiates_enrollment_repo_if_filepath_contains_enrollment_datasets
    create_and_load_district_repository
    filepath = { :enrollment => {
                 :kindergarten => "./test/data/district_test_fixture.csv"}}
    dr.instantiate_enrollment_repo(filepath)

    assert dr.er
  end

  def test_it_does_not_instantiates_enrollment_repo_if_filepath_does_not_contain_enrollment_datasets
    create_and_load_district_repository
    filepath = { :testing => {
                 :kindergarten => "./test/data/district_test_fixture.csv"}}
    dr.instantiate_enrollment_repo(filepath)

    assert dr.er
  end

  def test_it_populates_district_repo_with_multiple_pairs
    dr_test = DistrictRepository.new
    names = ["LARRY","CURLY","MOE"]
    dr_test.populate_district_repo(names)

    assert_equal "#<District:", dr_test.district_repo["LARRY"].to_s[0,11]
    assert_equal "#<District:", dr_test.district_repo["CURLY"].to_s[0,11]
    assert_equal "#<District:", dr_test.district_repo["MOE"].to_s[0,11]
  end

  def test_it_populates_district_repo_with_multiple_pairs_case_insensitive
    dr_test = DistrictRepository.new
    names = ["LARRY","curly","Moe"]
    dr_test.populate_district_repo(names)

    assert_equal "#<District:", dr_test.district_repo["LARRY"].to_s[0,11]
    assert_equal "#<District:", dr_test.district_repo["CURLY"].to_s[0,11]
    assert_equal "#<District:", dr_test.district_repo["MOE"].to_s[0,11]
  end

end
