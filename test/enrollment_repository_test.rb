require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'

require_relative '../lib/enrollment_repository'

class EnrollmentRepositoryTest < Minitest::Test

  def test_it_exists
    er = EnrollmentRepository.new()

    assert er
  end

  def test_it_extracts_a_file_location
    er = EnrollmentRepository.new()
    er.load_data({:enrollment=>{:kindergarten=>"./test/data/kindergarten_enrollment_sample.csv"}})

    assert_equal "./test/data/kindergarten_enrollment_sample.csv", er.file_path
  end

  def test_it_stores_districts
    er = EnrollmentRepository.new()
    er.load_data({:enrollment=>{:kindergarten=>"./test/data/kindergarten_enrollment_sample.csv"}})

    assert er.enrollments["colorado"]
    refute er.enrollments["ohio"]
    assert_equal 4, er.enrollments.length
  end

  def test_it_stores_enrollment_instances
    er = EnrollmentRepository.new()
    er.load_data({:enrollment=>{:kindergarten=>"./test/data/kindergarten_enrollment_sample.csv"}})

    assert_equal "#<Enrollment:", er.enrollments["colorado"].to_s[0,13]
  end

  def test_it_finds_instances_by_name
    er = EnrollmentRepository.new()
    er.load_data({:enrollment=>{:kindergarten=>"./test/data/kindergarten_enrollment_sample.csv"}})

    assert er.find_by_name("Academy 20")
    refute er.find_by_name("Test District")
    assert_equal "#<Enrollment:", er.find_by_name("Academy 20").to_s[0,13]
  end

end