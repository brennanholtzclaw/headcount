require_relative 'test_helper'
require_relative '../lib/enrollment'

class EnrollmentTest < Minitest::Test
  attr_reader :data, :e, :e_high_school

  def instantiate_enrollment_with_kindergarten_data
    @data = {:name=>"COLORADO",
            :kindergarten_participation=>{
              2007=>0.39465, 2006=>0.33677,
              2005=>0.27807, 2004=>0.24014,
              2008=>0.5357, 2009=>0.598,
              2010=>0.64019, 2011=>0.672,
              2012=>0.695, 2013=>0.70263,
              2014=>0.74118}}
    @e = Enrollment.new(data)
  end

  def instantiate_enrollment_with_highschool_and_kindergarten_data
    er = EnrollmentRepository.new
    er.load_data({:enrollment => {
                  :kindergarten => "./test/data/kindergarten_enrollment_sample.csv",
                  :high_school_graduation => "./test/data/high_school_grad_sample.csv"}})
    er
  end

  def test_it_is_initialized_with_data
    instantiate_enrollment_with_kindergarten_data

    assert_equal data, e.data
  end

  def test_returns_kindergarten_participation_by_year
    instantiate_enrollment_with_kindergarten_data

    assert_equal data[:kindergarten_participation], e.kindergarten_participation_by_year
  end

  def test_returns_kindergarten_participation_in_year
    instantiate_enrollment_with_kindergarten_data

    assert_equal 0.24014, e.kindergarten_participation_in_year(2004)
  end

  def test_returns_nil_if_no_data_included
    instantiate_enrollment_with_kindergarten_data

    assert_nil e.kindergarten_participation_in_year(1998)
  end

  def test_integration_with_by_year_and_enrollment_from_spec
    er = instantiate_enrollment_with_highschool_and_kindergarten_data
    enrollment = er.find_by_name("ACADEMY 20")
    expectation = {2010=>0.895, 2011=>0.895, 2012=>0.89, 2013=>0.914, 2014=>0.898}

    assert_equal expectation, enrollment.graduation_rate_by_year
  end

  def test_integration_with_in_year_and_enrollment_from_spec
    er = instantiate_enrollment_with_highschool_and_kindergarten_data
    enrollment = er.find_by_name("ACADEMY 20")
    expectation = 0.914

    assert_equal expectation, enrollment.graduation_rate_in_year(2013)
  end

end
