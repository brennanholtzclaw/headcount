require_relative 'test_helper'
require_relative '../lib/economic_profile_parser'
require_relative '../lib/economic_profile_repository'

class EconomicProfileParserTest < Minitest::Test

  def test_it_can_package_1_districts_data_from_median_hh_income_file
    epr = EconomicProfileRepository.new
    epr.load_data( {  :economic_profile => {
                      :median_household_income => "./test/data/median_household_income_sample.csv",
                      }
                    })
    expected = {[2005, 2009]=>85060,
                [2006, 2010]=>85450,
                [2008, 2012]=>89615,
                [2007, 2011]=>88099,
                [2009, 2013]=>89953
                }
    assert_equal expected, epr.find_by_name("ACADEMY 20").data[:median_household_income]
  end

  def test_it_can_package_1_districts_data_from_children_in_poverty_file
    epr = EconomicProfileRepository.new
    epr.load_data( {  :economic_profile => {
                      :children_in_poverty => "./test/data/school-aged_children_in_poverty_sample.csv",
                      }
                    })
    expected = {1995=>0.032, 1997=>0.035, 1999=>0.032,
                2000=>0.031, 2001=>0.029, 2002=>0.033,
                2003=>0.037, 2004=>0.034, 2005=>0.042,
                2006=>0.036, 2007=>0.039, 2008=>0.044,
                2009=>0.047, 2010=>0.058, 2011=>0.059,
                2012=>0.064, 2013=>0.048}

    assert_equal expected, epr.find_by_name("ACADEMY 20").data[:children_in_poverty]
  end

  def test_it_can_package_1_districts_data_from_free_lunch_file
    epr = EconomicProfileRepository.new
    epr.load_data( {  :economic_profile => {
                      :free_or_reduced_price_lunch => "./test/data/free_or_reduced_price_lunch_sample.csv",
                      }
                    })
    expected = {2014=>{:total=>976.0, :percentage=>0.08772}}

    assert_equal expected, epr.find_by_name("ACADEMY 20").data[:free_or_reduced_price_lunch]
  end

  def test_it_can_package_1_districts_data_from_title_i_file
    epr = EconomicProfileRepository.new
    epr.load_data( {  :economic_profile => {
                      :title_i => "./test/data/title_1_students_sample.csv",
                      }
                    })
    expected = {2009=>0.014, 2011=>0.011,
                2012=>0.011, 2013=>0.012,
                2014=>0.027}

    assert_equal expected, epr.find_by_name("ACADEMY 20").data[:title_i]
  end
  end