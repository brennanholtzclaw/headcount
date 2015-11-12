require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'

require_relative '../lib/enrollment_repository'

class EnrollmentRepositoryTest < Minitest::Test
  attr_reader :er

  def test_it_exists
    er = EnrollmentRepository.new()

    assert er
  end

  def create_and_setup_enrollment_repository
    @er = EnrollmentRepository.new()
    @er.load_data({:enrollment=>{:kindergarten=>"./test/data/kindergarten_enrollment_sample.csv"}})
  end

  def test_it_extracts_a_file_location
    create_and_setup_enrollment_repository

    assert_equal "./test/data/kindergarten_enrollment_sample.csv", er.file_path
  end

  def test_it_stores_districts
    create_and_setup_enrollment_repository

    assert er.enrollments["colorado"]
    refute er.enrollments["ohio"]
    assert_equal 4, er.enrollments.length
  end

  def test_it_stores_enrollment_instances
    create_and_setup_enrollment_repository

    assert_equal "#<Enrollment:", er.enrollments["colorado"].to_s[0,13]
  end

  def test_it_finds_instances_by_name
    create_and_setup_enrollment_repository

    assert er.find_by_name("Academy 20")
    refute er.find_by_name("Test District")
    assert_equal "#<Enrollment:", er.find_by_name("Academy 20").to_s[0,13]
  end

end