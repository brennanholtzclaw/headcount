#test_has_find_by_name method
###returns nil or an instance of Enrollment
###case insensitive search

#test_has_a_load_data method
###Module?
##creates an abject that is one line of data from file
###creates a hash where name is key and instance of Enrollment is value


require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/enrollment_repository'

class EnrollmentTest < Minitest::Test

  def test_it_accepts_data
    er = EnrollmentRepository.new
    er.load_data({
    :enrollment => {
      :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
    })

    assert er
  end

  def test_it_can_find_by_name
    skip
    er = EnrollmentRepository.new
    er.load_data({
    :enrollment => {
      :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
    })
    enrollment = er.find_by_name("ACADEMY 20")
  end

end
