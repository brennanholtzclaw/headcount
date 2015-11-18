require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require_relative '../lib/statewide_testing_repository'

class StatewideTestTest < Minitest::Test

  def setup_tests
    data = {:third_grade=>{2008=>{"Math"=>0.857, "Reading"=>0.866, "Writing"=>0.671}, 2009=>{"Math"=>0.824, "Reading"=>0.862, "Writing"=>0.706}, 2010=>{"Math"=>0.849, "Reading"=>0.864, "Writing"=>0.662}, 2011=>{"Math"=>0.819, "Reading"=>0.867, "Writing"=>0.678}, 2012=>{"Reading"=>0.87, "Math"=>0.83, "Writing"=>0.655}, 2013=>{"Math"=>0.855, "Reading"=>0.859, "Writing"=>0.669}, 2014=>{"Math"=>0.835, "Reading"=>0.831, "Writing"=>0.639}},
    :eighth_grade=>{2008=>{"Math"=>0.64, "Reading"=>0.843, "Writing"=>0.734}, 2009=>{"Math"=>0.656, "Reading"=>0.825, "Writing"=>0.701}, 2010=>{"Math"=>0.672, "Reading"=>0.863, "Writing"=>0.754}, 2011=>{"Reading"=>0.832, "Math"=>0.653, "Writing"=>0.746}, 2012=>{"Math"=>0.682, "Writing"=>0.738, "Reading"=>0.834}, 2013=>{"Math"=>0.661, "Reading"=>0.853, "Writing"=>0.751}, 2014=>{"Math"=>0.685, "Reading"=>0.827, "Writing"=>0.748}}}

    st = StatewideTest.new(data)
    st
  end

  def test_proficient_by_grade_returns_year_by_year_hash_of_scores_per_subject
    st = setup_tests
    third_grade =  {2008=>{"Math"=>0.857, "Reading"=>0.866, "Writing"=>0.671},
                    2009=>{"Math"=>0.824, "Reading"=>0.862, "Writing"=>0.706},
                    2010=>{"Math"=>0.849, "Reading"=>0.864, "Writing"=>0.662},
                    2011=>{"Math"=>0.819, "Reading"=>0.867, "Writing"=>0.678},
                    2012=>{"Reading"=>0.87, "Math"=>0.83, "Writing"=>0.655},
                    2013=>{"Math"=>0.855, "Reading"=>0.859, "Writing"=>0.669},
                    2014=>{"Math"=>0.835, "Reading"=>0.831, "Writing"=>0.639}}
    eighth_grade = {2008=>{"Math"=>0.64, "Reading"=>0.843, "Writing"=>0.734},
                    2009=>{"Math"=>0.656, "Reading"=>0.825, "Writing"=>0.701},
                    2010=>{"Math"=>0.672, "Reading"=>0.863, "Writing"=>0.754},
                    2011=>{"Reading"=>0.832, "Math"=>0.653, "Writing"=>0.746},
                    2012=>{"Math"=>0.682, "Writing"=>0.738, "Reading"=>0.834},
                    2013=>{"Math"=>0.661, "Reading"=>0.853, "Writing"=>0.751},
                    2014=>{"Math"=>0.685, "Reading"=>0.827, "Writing"=>0.748}}

    assert_equal third_grade, st.proficient_by_grade(3)
    assert_equal eighth_grade, st.proficient_by_grade(8)
  end

  def test_proficient_by_grade_raises_error_if_not_fed_eighth_or_third_grades
    skip
    st = setup_tests

    assert_equal 0, st.proficient_by_grade(5)
  end


end