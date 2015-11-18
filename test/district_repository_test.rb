require 'test_helper'
require './lib/district_repository'

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

  def create_and_load_district_repository_with_2_files
    dr2 = DistrictRepository.new
    dr2.load_data({ :enrollment => {
                    :kindergarten => "./test/data/kindergarten_enrollment_sample.csv",
                    :high_school_graduation => "./test/data/high_school_grad_sample.csv"}})
    dr2
  end

  def test_it_loads_files_and_creates_approp_number_of_district_instances
    dr_2 = create_and_load_district_repository_with_2_files

    assert_equal 6, dr_2.district_repo.count
  end

  def test_it_loads_files_and_creates_approp_number_of_enrollment_instances
    dr_2 = create_and_load_district_repository_with_2_files

    assert_equal 6, dr_2.er.enrollments.count
  end

  def test_it_loads_files_and_populates_enrollment_instances_with_data
    dr_2 = create_and_load_district_repository_with_2_files

    assert_equal 11, dr_2.er.enrollments["academy 20"].data["academy 20"][:kindergarten].count
    assert_equal 5, dr_2.er.enrollments["academy 20"].data["academy 20"][:high_school_graduation].count
  end

  def test_it_creates_an_enrollment_repo_when_using_load_data
    dr = DistrictRepository.new
    nested = { :statewide_testing => {
                    :third_grade => "./test/data/3rd_grade_students_stub.csv"}}
    dr.load_data(nested)
    dr.instantiate_statewide_testing_repo(nested)

    assert dr.str.statewide_testing.length > 5
  end

  def test_it_creates_enrollment_and_testing_repo
    dr = DistrictRepository.new
    nested = {:enrollment => {
                :kindergarten => "./test/data/kindergarten_enrollment_sample.csv"},
              :statewide_testing => {
                :third_grade => "./test/data/3rd_grade_students_stub.csv"}}
    dr.load_data(nested)

    assert dr.str.statewide_testing.length > 5
    assert dr.er.enrollments.length > 5
  end
end

# <DistrictRepository:0xXXXXXX
# @district_repo={"COLORADO"=>#<District:0xXXXXXX @district={:name=>"COLORADO"}>,
# "ACADEMY 20"=>#<District:0xXXXXXX @district={:name=>"ACADEMY 20"}>,
# "ADAMS COUNTY 14"=>#<District:0xXXXXXX @district={:name=>"ADAMS COUNTY 14"}>,
# "ADAMS-ARAPAHOE 28J"=>#<District:0xXXXXXX @district={:name=>"ADAMS-ARAPAHOE 28J"}>,
# "AGATE 300"=>#<District:0xXXXXXX @district={:name=>"AGATE 300"}>,
# "AGUILAR REORGANIZED 6"=>#<District:0xXXXXXX @district={:name=>"AGUILAR REORGANIZED 6"}>},
# @nested_filepaths={:statewide_testing=>{:third_grade=>"./test/data/3rd_grade_students_stub.csv"}}>
#
