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
end