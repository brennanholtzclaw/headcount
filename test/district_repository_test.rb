require 'minitest/autorun'
require 'minitest/pride'
require './lib/district_repository'
require 'csv'


class DistrictRepositoryTest < Minitest::Test

  def test_it_can_load_data
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./test/district_test_fixture.csv"
      }
    })
    #just don't break#
  end

  def test_load_data_creates_hash_for_listed_districts
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./test/district_test_fixture.csv"
      }
    })

    assert dr.district_repo.length > 2
    assert_equal 14, dr.district_repo.length
  end

  def test_it_can_find_by_a_full_unique_name
    skip
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./test/district_test_fixture.csv"
      }
    })

    assert_equal District.new("ACADEMY 20"), dr.find_by_name("ACADEMY 20")
  end

  def test_it_can_find_by_a_full_unique_downcased_name
    skip
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./test/district_test_fixture.csv"
      }
    })

    assert_equal District.new("ACADEMY 20"), dr.find_by_name("academy 20")
  end

  def test_find_by_name_returns_nil_if_no_match
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./test/district_test_fixture.csv"
      }
    })

    assert_equal nil, dr.find_by_name("zzz")
  end

  def test_find_all_matching_returns_empty_for_no_possible_match
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./test/district_test_fixture.csv"
      }
    })

    assert_equal [], dr.find_all_matching("zzz")
  end

  def test_find_all_matching_returns_array_for_single_possible_match
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./test/district_test_fixture.csv"
      }
    })

    assert_equal ["ACADEMY 20"], dr.find_all_matching("academy 20")
  end

  def test_find_all_matching_returns_two_element_array_for_double_possible_match
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./test/district_test_fixture.csv"
      }
    })

    assert_equal ["CHEYENNE COUNTY RE-5", "CHEYENNE MOUNTAIN 12"], dr.find_all_matching("CHEYENNE")
  end

  def test_find_all_lists_empty_array_if_no_districts_found
    dr = DistrictRepository.new

    assert_equal [], dr.find_all
  end

  def test_find_all_lists_array_of_unique_districts
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./test/district_test_fixture.csv"
      }
    })

    expectation = ["Colorado", "ACADEMY 20", "ADAMS COUNTY 14", "BIG SANDY 100J", "CHERAW 31", "CHEYENNE COUNTY RE-5", "CHEYENNE MOUNTAIN 12", "CLEAR CREEK RE-1", "COLORADO SPRINGS 11", "COTOPAXI RE-3", "CREEDE CONSOLIDATED 1", "CRIPPLE CREEK-VICTOR RE-1", "CROWLEY COUNTY RE-1-J", "CUSTER COUNTY SCHOOL DISTRICT C-1"]

    assert_equal expectation, dr.find_all
    assert_equal 14, dr.find_all.count
  end

  def test_it_creates_an_enrollment_repo_when_using_load_data
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./test/district_test_fixture.csv"
      }
    })

    assert dr.er.enrollments.length > 5
  end
end
