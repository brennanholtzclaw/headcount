require 'test_helper'
require_relative '../lib/statewide_testing_parser.rb'

class StatewideParserTest < Minitest::Test

  def test_it_reads_file_and_returns_one_districts_data_for_one_file
    parser = StatewideTestParser.new
    district = "Academy 20"
    label = :third_grade
    filepath = "./test/data/3rd_grade_students_stub.csv"
    expected = {:third_grade => {2008=>{"Math"=>0.857, "Reading"=>0.866, "Writing"=>0.671},
                2009=>{"Math"=>0.824, "Reading"=>0.862, "Writing"=>0.706},
                2010=>{"Math"=>0.849, "Reading"=>0.864, "Writing"=>0.662},
                2011=>{"Math"=>0.819, "Reading"=>0.867, "Writing"=>0.678},
                2012=>{"Reading"=>0.87, "Math"=>0.83, "Writing"=>0.655},
                2013=>{"Math"=>0.855, "Reading"=>0.859, "Writing"=>0.669},
                2014=>{"Math"=>0.835, "Reading"=>0.831, "Writing"=>0.639}}}

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

    expected_third = {2008=>{"Math"=>0.857, "Reading"=>0.866, "Writing"=>0.671},
                      2009=>{"Math"=>0.824, "Reading"=>0.862, "Writing"=>0.706},
                      2010=>{"Math"=>0.849, "Reading"=>0.864, "Writing"=>0.662},
                      2011=>{"Math"=>0.819, "Reading"=>0.867, "Writing"=>0.678},
                      2012=>{"Reading"=>0.87, "Math"=>0.83, "Writing"=>0.655},
                      2013=>{"Math"=>0.855, "Reading"=>0.859, "Writing"=>0.669},
                      2014=>{"Math"=>0.835, "Reading"=>0.831, "Writing"=>0.639}}

    expected_eighth = { 2008=>{"Math"=>0.64, "Reading"=>0.843, "Writing"=>0.734},
                        2009=>{"Math"=>0.656, "Reading"=>0.825, "Writing"=>0.701},
                        2010=>{"Math"=>0.672, "Reading"=>0.863, "Writing"=>0.754},
                        2011=>{"Reading"=>0.832, "Math"=>0.653, "Writing"=>0.746},
                        2012=>{"Math"=>0.682, "Writing"=>0.738, "Reading"=>0.834},
                        2013=>{"Math"=>0.661, "Reading"=>0.853, "Writing"=>0.751},
                        2014=>{"Math"=>0.685, "Reading"=>0.827, "Writing"=>0.748}}

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

    expected_math = { "All Students"=>{2011=>0.68, 2012=>0.689, 2013=>0.697, 2014=>0.699},
                      "Asian"=>{2011=>0.817, 2012=>0.818, 2013=>0.805, 2014=>0.8},
                      "Black"=>{2011=>0.425, 2012=>0.425, 2013=>0.44, 2014=>0.421},
                      "Hawaiian/Pacific Islander"=>{2011=>0.569, 2012=>0.571, 2013=>0.683, 2014=>0.682},
                      "Hispanic"=>{2011=>0.568, 2012=>0.572, 2013=>0.588, 2014=>0.605},
                      "Native American"=>{2011=>0.614, 2012=>0.571, 2013=>0.593, 2014=>0.544},
                      "Two or more"=>{2011=>0.677, 2012=>0.69, 2013=>0.697, 2014=>0.693},
                      "White"=>{2011=>0.707, 2012=>0.714, 2013=>0.721, 2014=>0.723}}

    expected_writing = {"All Students"=>{2011=>0.719, 2012=>0.706, 2013=>0.72, 2014=>0.716},
                        "Asian"=>{2011=>0.827, 2012=>0.808, 2013=>0.811, 2014=>0.789},
                        "Black"=>{2011=>0.515, 2012=>0.504, 2013=>0.482, 2014=>0.519},
                        "Hawaiian/Pacific Islander"=>{2011=>0.726, 2012=>0.683, 2013=>0.717, 2014=>0.727},
                        "Hispanic"=>{2011=>0.607, 2012=>0.598, 2013=>0.623, 2014=>0.624},
                        "Native American"=>{2011=>0.6, 2012=>0.589, 2013=>0.61, 2014=>0.621},
                        "Two or more"=>{2011=>0.727, 2012=>0.719, 2013=>0.747, 2014=>0.732},
                        "White"=>{2011=>0.74, 2012=>0.726, 2013=>0.741, 2014=>0.735}}

    expected_reading = {"All Students"=>{2011=>0.83, 2012=>0.846, 2013=>0.845, 2014=>0.841},
                        "Asian"=>{2011=>0.898, 2012=>0.893, 2013=>0.902, 2014=>0.855},
                        "Black"=>{2011=>0.662, 2012=>0.695, 2013=>0.67, 2014=>0.704},
                        "Hawaiian/Pacific Islander"=>{2011=>0.745, 2012=>0.833, 2013=>0.867, 2014=>0.932},
                        "Hispanic"=>{2011=>0.749, 2012=>0.772, 2013=>0.773, 2014=>0.008},
                        "Native American"=>{2011=>0.817, 2012=>0.786, 2013=>0.814, 2014=>0.007},
                        "Two or more"=>{2011=>0.842, 2012=>0.846, 2013=>0.856, 2014=>0.009},
                        "White"=>{2011=>0.851, 2012=>0.862, 2013=>0.861, 2014=>0.009}}

    assert_equal expected_math, parser.find_district_data_in_mult_files(district,filepath)[:math]
    assert_equal expected_reading, parser.find_district_data_in_mult_files(district,filepath)[:reading]
    assert_equal expected_writing, parser.find_district_data_in_mult_files(district,filepath)[:writing]
  end

end
