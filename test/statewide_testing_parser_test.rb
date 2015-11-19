require_relative 'test_helper'
require_relative '../lib/statewide_testing_parser.rb'

class StatewideParserTest < Minitest::Test

  def test_it_reads_file_and_returns_one_districts_data_for_one_file
    parser = StatewideTestParser.new
    district = "Academy 20"
    label = :third_grade
    filepath = "./test/data/3rd_grade_students_stub.csv"
    expected = {:third_grade=>{
                  2008=>{:math=>0.857, :reading=>0.866, :writing=>0.671},
                  2009=>{:math=>0.824, :reading=>0.862, :writing=>0.706},
                  2010=>{:math=>0.849, :reading=>0.864, :writing=>0.662},
                  2011=>{:math=>0.819, :reading=>0.867, :writing=>0.678},
                  2012=>{:reading=>0.87, :math=>0.83, :writing=>0.655},
                  2013=>{:math=>0.855, :reading=>0.859, :writing=>0.669},
                  2014=>{:math=>0.835, :reading=>0.831, :writing=>0.639}
                  }
                }

    assert_equal expected, parser.reads_file_and_returns_1_districts_data_for_one_file(district, label, filepath)
  end

  def test_it_reads_file_and_returns_one_districts_data_for_multiple_files
    parser = StatewideTestParser.new
    district = "Academy 20"
    filepath = {  :statewide_testing => {
                  :third_grade => "./test/data/3rd_grade_students_stub.csv",
                  :eighth_grade => "./test/data/8th_grade_students_stub.csv",
                  :math => "./test/data/average_race_math.csv",
                  :reading => "./test/data/average_race_reading.csv",
                  :writing => "./test/data/average_race_writing.csv"}}

    expected_third = {2008=>{:math=>0.857, :reading=>0.866, :writing=>0.671},
                      2009=>{:math=>0.824, :reading=>0.862, :writing=>0.706},
                      2010=>{:math=>0.849, :reading=>0.864, :writing=>0.662},
                      2011=>{:math=>0.819, :reading=>0.867, :writing=>0.678},
                      2012=>{:reading=>0.87, :math=>0.83, :writing=>0.655},
                      2013=>{:math=>0.855, :reading=>0.859, :writing=>0.669},
                      2014=>{:math=>0.835, :reading=>0.831, :writing=>0.639}
                      }

    expected_eighth = { 2008=>{:math=>0.64, :reading=>0.843, :writing=>0.734},
                        2009=>{:math=>0.656, :reading=>0.825, :writing=>0.701},
                        2010=>{:math=>0.672, :reading=>0.863, :writing=>0.754},
                        2011=>{:reading=>0.832, :math=>0.653, :writing=>0.746},
                        2012=>{:math=>0.682, :writing=>0.738, :reading=>0.834},
                        2013=>{:math=>0.661, :reading=>0.853, :writing=>0.751},
                        2014=>{:math=>0.685, :reading=>0.827, :writing=>0.748}
                      }

    assert_equal expected_third, parser.find_district_data_in_mult_files(district,filepath)[:third_grade]
    assert_equal expected_eighth, parser.find_district_data_in_mult_files(district,filepath)[:eighth_grade]
  end

  def test_it_reads_math_reading_and_writing_tests
    parser = StatewideTestParser.new
    district = "Academy 20"
    filepath = {  :statewide_testing => {
                  :third_grade => "./test/data/3rd_grade_students_stub.csv",
                  :eighth_grade => "./test/data/8th_grade_students_stub.csv",
                  :math => "./test/data/average_race_math.csv",
                  :reading => "./test/data/average_race_reading.csv",
                  :writing => "./test/data/average_race_writing.csv"}}

    expected_math = { :all_students=>{2011=>0.68, 2012=>0.689, 2013=>0.697, 2014=>0.699},
                      :asian=>{2011=>0.817, 2012=>0.818, 2013=>0.805, 2014=>0.8},
                      :black=>{2011=>0.425, 2012=>0.425, 2013=>0.44, 2014=>0.421},
                      :hawaiian_pacific_islander=>{2011=>0.569, 2012=>0.571, 2013=>0.683, 2014=>0.682},
                      :hispanic=>{2011=>0.568, 2012=>0.572, 2013=>0.588, 2014=>0.605},
                      :native_american=>{2011=>0.614, 2012=>0.571, 2013=>0.593, 2014=>0.544},
                      :two_or_more=>{2011=>0.677, 2012=>0.69, 2013=>0.697, 2014=>0.693},
                      :white=>{2011=>0.707, 2012=>0.714, 2013=>0.721, 2014=>0.723}}

    expected_writing = {:all_students=>{2011=>0.719, 2012=>0.706, 2013=>0.72, 2014=>0.716},
                        :asian=>{2011=>0.827, 2012=>0.808, 2013=>0.811, 2014=>0.789},
                        :black=>{2011=>0.515, 2012=>0.504, 2013=>0.482, 2014=>0.519},
                        :hawaiian_pacific_islander=>{2011=>0.726, 2012=>0.683, 2013=>0.717, 2014=>0.727},
                        :hispanic=>{2011=>0.607, 2012=>0.598, 2013=>0.623, 2014=>0.624},
                        :native_american=>{2011=>0.6, 2012=>0.589, 2013=>0.61, 2014=>0.621},
                        :two_or_more=>{2011=>0.727, 2012=>0.719, 2013=>0.747, 2014=>0.732},
                        :white=>{2011=>0.74, 2012=>0.726, 2013=>0.741, 2014=>0.735}}

    expected_reading = {:all_students=>{2011=>0.83, 2012=>0.846, 2013=>0.845, 2014=>0.841},
                        :asian=>{2011=>0.898, 2012=>0.893, 2013=>0.902, 2014=>0.855},
                        :black=>{2011=>0.662, 2012=>0.695, 2013=>0.67, 2014=>0.704},
                        :hawaiian_pacific_islander=>{2011=>0.745, 2012=>0.833, 2013=>0.867, 2014=>0.932},
                        :hispanic=>{2011=>0.749, 2012=>0.772, 2013=>0.773, 2014=>0.008},
                        :native_american=>{2011=>0.817, 2012=>0.786, 2013=>0.814, 2014=>0.007},
                        :two_or_more=>{2011=>0.842, 2012=>0.846, 2013=>0.856, 2014=>0.009},
                        :white=>{2011=>0.851, 2012=>0.862, 2013=>0.861, 2014=>0.009}}

    assert_equal expected_math, parser.find_district_data_in_mult_files(district,filepath)[:math]
    assert_equal expected_reading, parser.find_district_data_in_mult_files(district,filepath)[:reading]
    assert_equal expected_writing, parser.find_district_data_in_mult_files(district,filepath)[:writing]
  end

end
