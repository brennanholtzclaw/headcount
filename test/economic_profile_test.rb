require_relative 'test_helper'
require_relative '../lib/economic_profile'
require_relative '../lib/economic_profile_repository'

class EconomicProfileTest < Minitest::Test

  def instantiate_and_load_files
    epr = EconomicProfileRepository.new
    epr.load_data({
      :economic_profile => {
        :median_household_income => "./test/data/median_household_income_sample.csv",
        :children_in_poverty => "./test/data/school-aged_children_in_poverty_sample.csv",
        :free_or_reduced_price_lunch => "./test/data/free_or_reduced_price_lunch_sample.csv",
        :title_i => "./test/data/title_1_students_sample.csv"
      }
    })
    epr
  end

  def test_it_finds_median_income
    epr = instantiate_and_load_files

    assert_equal 85060, epr.find_by_name("ACADEMY 20").estimated_median_household_income_in_year(2005)
  end

  def test_it_raises_error_if_unknown_year_for_median_income
    epr = instantiate_and_load_files

    assert_raises "UnknownDataError" do
      epr.find_by_name("ACADEMY 20").estimated_median_household_income_in_year(2001234)
    end
  end

  def test_it_finds_median_income_average
    epr = instantiate_and_load_files

    assert_equal 87635, epr.find_by_name("ACADEMY 20").estimated_median_household_income_average
  end


  def test_it_finds_children_in_poverty_for_a_given_year
    epr = instantiate_and_load_files

    assert_equal 0.036, epr.find_by_name("ACADEMY 20").children_in_poverty_in_year(2006)
  end

  def test_it_raises_error_if_unknown_year_for_children_in_poverty_for_a_given_year
    epr = instantiate_and_load_files

    assert_raises "UnknownDataError" do
      epr.find_by_name("ACADEMY 20").children_in_poverty_in_year(20036)
    end
  end

  def test_it_finds_reduced_price_meal_data_in_year
    epr = instantiate_and_load_files

    assert_equal 0.12743, epr.find_by_name("ACADEMY 20").free_or_reduced_price_lunch_in_year(2014)
  end

# This method takes one parameter:
#
# year as an integer
# A call to this method with an unknown year should raise an UnknownDataError.
#
# The method returns a float representing a percentage.
#
# Example:
#
# economic_profile.free_or_reduced_price_lunch_in_year(2014)
# => 0.023

























end