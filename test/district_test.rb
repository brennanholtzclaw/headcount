require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/district'
require_relative '../lib/district_repository'

class DistrictTest < Minitest::Test

  def test_it_accepts_names_in_spec_format
    dist1 = District.new({:name => "denver"})
    dist2 = District.new({:name => "academy20"})

    refute_equal "denver",    dist1.name
    assert_equal "DENVER",    dist1.name
    assert_equal "ACADEMY20", dist2.name
  end

  def test_district_instance_calls_statewide_data
    dr = DistrictRepository.new
    nested = {:enrollment => {
                :kindergarten => "./test/data/kindergarten_enrollment_sample.csv"},
              :statewide_testing => {
                :third_grade => "./test/data/3rd_grade_students_stub.csv"}}
    dr.load_data(nested)

    district = dr.find_by_name("ACADEMY 20")

    assert_equal "#<StatewideTest", district.statewide_test.to_s[0,15]
    end
end
