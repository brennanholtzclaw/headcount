require_relative 'test_helper'
require_relative '../lib/statewide_testing_repository'

class StatewideTestRepositoryTest < Minitest::Test

  def test_it_reads_1_file_and_does_every_fucking_thing_at_once_and_shit_does_it_feel_good
    str = StatewideTestRepository.new
    str.load_data({
      :statewide_testing => {
        :third_grade => "./test/data/3rd_grade_students_stub.csv"}})

    assert_equal "#<StatewideTest", str.find_by_name("ACADEMY 20").to_s[0,15]
  end

  def test_it_does_every_fucking_thing_at_once_and_shit_does_it_feel_good
    str = StatewideTestRepository.new
    str.load_data({
      :statewide_testing => {
        :third_grade => "./test/data/3rd_grade_students_stub.csv",
        :eighth_grade => "./test/data/8th_grade_students_stub.csv",
        :math => "./test/data/average_race_math.csv",
        :reading => "./test/data/average_race_reading.csv",
        :writing => "./test/data/average_race_writing.csv"}})

    assert_equal "#<StatewideTest", str.find_by_name("ACADEMY 20").to_s[0,15]
  end

end
