require_relative 'test_helper'
require_relative '../lib/statewide_testing_repository'

class StatewideTestTest < Minitest::Test

  def setup_data_for_tests
    data = {:third_grade=>{ 2008=>{:math=>0.857, :reading=>0.866, :writing=>0.671},
                            2009=>{:math=>0.824, :reading=>0.862, :writing=>0.706},
                            2010=>{:math=>0.849, :reading=>0.864, :writing=>0.662},
                            2011=>{:math=>0.819, :reading=>0.867, :writing=>0.678},
                            2012=>{:reading=>0.87, :math=>0.83, :writing=>0.655},
                            2013=>{:math=>0.855, :reading=>0.859, :writing=>0.669},
                            2014=>{:math=>0.835, :reading=>0.831, :writing=>0.639}},
    :eighth_grade=>{2008=>{:math=>0.64, :reading=>0.843, :writing=>0.734},
                    2009=>{:math=>0.656, :reading=>0.825, :writing=>0.701},
                    2010=>{:math=>0.672, :reading=>0.863, :writing=>0.754},
                    2011=>{:reading=>0.832, :math=>0.653, :writing=>0.746},
                    2012=>{:math=>0.682, :writing=>0.738, :reading=>0.834},
                    2013=>{:math=>0.661, :reading=>0.853, :writing=>0.751},
                    2014=>{:math=>0.685, :reading=>0.827, :writing=>0.748}},
    :math => { :all_students=>{2011=>0.68, 2012=>0.689, 2013=>0.697, 2014=>0.699},
                      :asian=>{2011=>0.817, 2012=>0.818, 2013=>0.805, 2014=>0.8},
                      :black=>{2011=>0.425, 2012=>0.425, 2013=>0.44, 2014=>0.421},
                      :pacific_islander=>{2011=>0.569, 2012=>0.571, 2013=>0.683, 2014=>0.682},
                      :hispanic=>{2011=>0.568, 2012=>0.572, 2013=>0.588, 2014=>0.605},
                      :native_american=>{2011=>0.614, 2012=>0.571, 2013=>0.593, 2014=>0.544},
                      :two_or_more=>{2011=>0.677, 2012=>0.69, 2013=>0.697, 2014=>0.693},
                      :white=>{2011=>0.707, 2012=>0.714, 2013=>0.721, 2014=>0.723}},
    :writing => {:all_students=>{2011=>0.719, 2012=>0.706, 2013=>0.72, 2014=>0.716},
                        :asian=>{2011=>0.827, 2012=>0.808, 2013=>0.811, 2014=>0.789},
                        :black=>{2011=>0.515, 2012=>0.504, 2013=>0.482, 2014=>0.519},
                        :pacific_islander=>{2011=>0.726, 2012=>0.683, 2013=>0.717, 2014=>0.727},
                        :hispanic=>{2011=>0.607, 2012=>0.598, 2013=>0.623, 2014=>0.624},
                        :native_american=>{2011=>0.6, 2012=>0.589, 2013=>0.61, 2014=>0.621},
                        :two_or_more=>{2011=>0.727, 2012=>0.719, 2013=>0.747, 2014=>0.732},
                        :white=>{2011=>0.74, 2012=>0.726, 2013=>0.741, 2014=>0.735}},
    :reading => {:all_students=>{2011=>0.83, 2012=>0.846, 2013=>0.845, 2014=>0.841},
                        :asian=>{2011=>0.898, 2012=>0.893, 2013=>0.902, 2014=>0.855},
                        :black=>{2011=>0.662, 2012=>0.695, 2013=>0.67, 2014=>0.704},
                        :pacific_islander=>{2011=>0.745, 2012=>0.833, 2013=>0.867, 2014=>0.932},
                        :hispanic=>{2011=>0.749, 2012=>0.772, 2013=>0.773, 2014=>0.008},
                        :native_american=>{2011=>0.817, 2012=>0.786, 2013=>0.814, 2014=>0.007},
                        :two_or_more=>{2011=>0.842, 2012=>0.846, 2013=>0.856, 2014=>0.009},
                        :white=>{2011=>0.851, 2012=>0.862, 2013=>0.861, 2014=>0.009}}}

    st = StatewideTest.new(data)
    st
  end

  def test_proficient_by_grade_returns_year_by_year_hash_of_scores_per_subject
    st = setup_data_for_tests
    third_grade =  {2008=>{:math=>0.857, :reading=>0.866, :writing=>0.671},
                    2009=>{:math=>0.824, :reading=>0.862, :writing=>0.706},
                    2010=>{:math=>0.849, :reading=>0.864, :writing=>0.662},
                    2011=>{:math=>0.819, :reading=>0.867, :writing=>0.678},
                    2012=>{:reading=>0.87, :math=>0.83, :writing=>0.655},
                    2013=>{:math=>0.855, :reading=>0.859, :writing=>0.669},
                    2014=>{:math=>0.835, :reading=>0.831, :writing=>0.639}}
    eighth_grade = {2008=>{:math=>0.64, :reading=>0.843, :writing=>0.734},
                    2009=>{:math=>0.656, :reading=>0.825, :writing=>0.701},
                    2010=>{:math=>0.672, :reading=>0.863, :writing=>0.754},
                    2011=>{:reading=>0.832, :math=>0.653, :writing=>0.746},
                    2012=>{:math=>0.682, :writing=>0.738, :reading=>0.834},
                    2013=>{:math=>0.661, :reading=>0.853, :writing=>0.751},
                    2014=>{:math=>0.685, :reading=>0.827, :writing=>0.748}}

    assert_equal third_grade, st.proficient_by_grade(3)

    assert_equal eighth_grade, st.proficient_by_grade(8)
  end

  def test_proficient_by_grade_raises_error_if_not_fed_eighth_or_third_grades
    st = setup_data_for_tests

    assert_raises "UnknownDataError" do
      st.proficient_by_grade(9)
    end
  end

  def test_proficient_by_race_raises_error_if_race_unknown
    st = setup_data_for_tests

    assert_raises "UnknownRaceError" do
      st.proficient_by_race_or_ethnicity(:latino)
    end
  end

  def test_it_finds_list_of_all_years_in_data
    st = setup_data_for_tests

    assert_equal [2011,2012,2013,2014], st.all_race_file_years
  end

  def test_it_finds_list_of_all_years_in_data_when_files_contain_different_years
    data = { :math => { :all_students=>{2011=>0.68, 2012=>0.689, 2013=>0.697, 2014=>0.699},
                      :asian=>{2011=>0.817, 2012=>0.818, 2013=>0.805, 2014=>0.8},
                      :black=>{2011=>0.425, 2012=>0.425, 2013=>0.44, 2014=>0.421},
                      :pacific_islander=>{2011=>0.569, 2012=>0.571, 2013=>0.683, 2014=>0.682},
                      :hispanic=>{2011=>0.568, 2012=>0.572, 2013=>0.588, 2014=>0.605},
                      :native_american=>{2011=>0.614, 2012=>0.571, 2013=>0.593, 2014=>0.544},
                      :two_or_more=>{2011=>0.677, 2012=>0.69, 2013=>0.697, 2014=>0.693},
                      :white=>{2011=>0.707, 2012=>0.714, 2013=>0.721, 2014=>0.723, 2015=>0.841}},
    :writing => {:all_students=>{2011=>0.719, 2012=>0.706, 2013=>0.72, 2014=>0.716},
                        :asian=>{2011=>0.827, 2012=>0.808, 2013=>0.811, 2014=>0.789},
                        :black=>{2011=>0.515, 2012=>0.504, 2013=>0.482, 2014=>0.519},
                        :pacific_islander=>{2011=>0.726, 2012=>0.683, 2013=>0.717, 2014=>0.727},
                        :hispanic=>{2011=>0.607, 2012=>0.598, 2013=>0.623, 2014=>0.624},
                        :native_american=>{2011=>0.6, 2012=>0.589, 2013=>0.61, 2014=>0.621},
                        :two_or_more=>{2011=>0.727, 2012=>0.719, 2013=>0.747, 2014=>0.732},
                        :white=>{2011=>0.74, 2012=>0.726, 2013=>0.741, 2014=>0.735}},
    :reading => {:all_students=>{2011=>0.83, 2012=>0.846, 2013=>0.845, 2014=>0.841},
                        :asian=>{2011=>0.898, 2012=>0.893, 2013=>0.902, 2014=>0.855},
                        :black=>{2011=>0.662, 2012=>0.695, 2013=>0.67, 2014=>0.704},
                        :pacific_islander=>{2011=>0.745, 2012=>0.833, 2013=>0.867, 2014=>0.932},
                        :hispanic=>{2011=>0.749, 2012=>0.772, 2013=>0.773, 2014=>0.008, 2016=>0.841},
                        :native_american=>{2011=>0.817, 2012=>0.786, 2013=>0.814, 2014=>0.007},
                        :two_or_more=>{2011=>0.842, 2012=>0.846, 2013=>0.856, 2014=>0.009},
                        :white=>{2011=>0.851, 2012=>0.862, 2013=>0.861, 2014=>0.009}}}

    st = StatewideTest.new(data)
    st

    assert_equal [2011,2012,2013,2014,2015,2016], st.all_race_file_years
  end

  def test_it_finds_all_test_scores_when_given_race_and_year
    st = setup_data_for_tests
    expected = {math: 0.817, reading: 0.898, writing: 0.827}

    assert_equal expected, st.race_file_scores(:asian,2011)
  end

  def test_it_finds_all_test_scores_when_given_race_and_year_exception
    st = setup_data_for_tests
    expected = {math: 0.817, reading: 0.898, writing: 0.827}

    assert_raises "UnknownRaceError" do
      st.race_file_scores(:foreigner, 2011)
    end
  end

  def test_it_finds_data_by_race
    st = setup_data_for_tests
    expected = { 2011=>{:math=>0.817, :reading=>0.898, :writing=>0.827},
                  2012=>{:math=>0.818, :reading=>0.893, :writing=>0.808},
                  2013=>{:math=>0.805, :reading=>0.902, :writing=>0.811},
                  2014=>{:math=>0.8, :reading=>0.855, :writing=>0.789}}

    assert_equal expected, st.proficient_by_race_or_ethnicity(:asian)
  end

  def test_it_finds_data_by_race_that_doesnt_match_correctly
    st = setup_data_for_tests
    expected = {2011=>{:math=>0.569, :reading=>0.745, :writing=>0.726},
                2012=>{:math=>0.571, :reading=>0.833, :writing=>0.683},
                2013=>{:math=>0.683, :reading=>0.867, :writing=>0.717},
                2014=>{:math=>0.682, :reading=>0.932, :writing=>0.727}}

    assert_equal expected, st.proficient_by_race_or_ethnicity(:pacific_islander)
  end

  def test_it_raises_error_for_race_that_doesnt_exist_in_list
    st = setup_data_for_tests
    expected = {2011=>{:math=>0.569, :reading=>0.745, :writing=>0.726},
                2012=>{:math=>0.571, :reading=>0.833, :writing=>0.683},
                2013=>{:math=>0.683, :reading=>0.867, :writing=>0.717},
                2014=>{:math=>0.682, :reading=>0.932, :writing=>0.727}}

    assert_raises "UnknownRaceError" do
      st.proficient_by_race_or_ethnicity(:foreigner)
    end
  end

  def test_it_finds_proficiency_by_subject_grade_and_year
    st = setup_data_for_tests

    assert_equal 0.857, st.proficient_for_subject_by_grade_in_year(:math, 3, 2008)
  end

  def test_raises_an_error_for_an_unknown_subject
    st = setup_data_for_tests

    assert_raises "UnknownDataError" do
      st.proficient_for_subject_by_grade_in_year(:rithmatic, 3, 2011)
    end
  end

  def test_raises_an_error_for_an_unknown_grade
    st = setup_data_for_tests

    assert_raises "UnknownDataError" do
      st.proficient_for_subject_by_grade_in_year(:math, 4, 2011)
    end
  end

  def test_raises_an_error_for_an_unknown_year
      st = setup_data_for_tests

    assert_raises "UnknownDataError" do
      st.proficient_for_subject_by_grade_in_year(:math, 3, 2015)
    end
  end

  def test_it_finds_proficiency_by_subject_race_and_year
    st = setup_data_for_tests

    assert_equal 0.818, st.proficient_for_subject_by_race_in_year(:math, :asian, 2012)
  end

  def test_raises_an_error_for_an_unknown_grade_level
    st = setup_data_for_tests

    assert "UnknownDataError" do
      st.proficient_for_subject_by_grade_in_year(:math, 6, 2011)
    end
  end

  def test_raises_an_error_for_an_unknown_subject_in_other_method
    st = setup_data_for_tests

    assert "UnknownDataError" do
    st.proficient_for_subject_by_grade_in_year(:rithmatic, 3, 2008)
    end
  end

  def test_raises_an_error_for_an_unknown_year_in_other_method
    st = setup_data_for_tests

    assert "UnknownDataError" do
      st.proficient_for_subject_by_grade_in_year(:math, 3, 2016)
    end
  end
end
