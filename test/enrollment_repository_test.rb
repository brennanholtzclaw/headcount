require 'test_helper'
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

  def create_and_setup_enrollment_repository_w_2_files
    er = EnrollmentRepository.new
    er.load_data({
      :enrollment => {
        :kindergarten => "./test/data/kindergarten_enrollment_sample.csv",
        :high_school_graduation => "./test/data/high_school_grad_sample.csv"
        }
        })
    er
  end

  def test_it_extracts_a_file_location
    create_and_setup_enrollment_repository

    assert_equal "./test/data/kindergarten_enrollment_sample.csv", er.filepath[:enrollment][:kindergarten]
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
    expected = '#<Enrollment:0xXXXXXX @data={"academy 20"=>{:kindergarten=>{2007=>0.392, 2006=>0.354, 2005=>0.267, 2004=>0.302, 2008=>0.385, 2009=>0.39, 2010=>0.436, 2011=>0.489, 2012=>0.479, 2013=>0.488, 2014=>0.49}}}>'

    assert_equal "#<Enrollment:", er.find_by_name("Academy 20").to_s[0,13]
    assert_equal "#<Enrollment:", er.find_by_name("ACADEMY 20").to_s[0,13]
  end

  def test_it_can_extract_filepath_from_second_file_passed_in
    er = create_and_setup_enrollment_repository_w_2_files

    assert_equal "./test/data/kindergarten_enrollment_sample.csv" , er.filepath[:enrollment][:kindergarten]
    assert_equal "./test/data/high_school_grad_sample.csv", er.filepath[:enrollment][:high_school_graduation]
    end

    def test_it_prepares_data_in_format_parser_can_accept
      er = create_and_setup_enrollment_repository_w_2_files

      expected = {:kindergarten => "./test/data/kindergarten_enrollment_sample.csv", :high_school_graduation => "./test/data/high_school_grad_sample.csv"}

      assert_equal expected, er.filepath[:enrollment]
    end

    def test_it_finds_all_data_for_given_instance
      er = create_and_setup_enrollment_repository_w_2_files

      expected = {"academy 20"=>{:kindergarten=>{2007=>0.392, 2006=>0.354, 2005=>0.267, 2004=>0.302, 2008=>0.385, 2009=>0.39, 2010=>0.436, 2011=>0.489, 2012=>0.479, 2013=>0.488, 2014=>0.49}, :high_school_graduation=>{2010=>0.895, 2011=>0.895, 2012=>0.89, 2013=>0.914, 2014=>0.898}}}

      assert_equal expected, er.find_by_name("Academy 20").data
    end

end
