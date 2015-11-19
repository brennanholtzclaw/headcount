require_relative 'test_helper'
require_relative '../lib/economic_profile_repository'

class EconomicProfileRepositoryTest < Minitest::Test

  def test_it_loads_economic_profile_data
    epr = EconomicProfileRepository.new
    epr.load_data({
      :economic_profile => {
        :median_household_income => "./test/data/median_household_income_sample.csv",
        :children_in_poverty => "./test/data/school-aged_children_in_poverty_sample.csv",
        :free_or_reduced_price_lunch => "./test/data/free_or_reduced_price_lunch_sample.csv",
        :title_i => "./test/data/title_1_students_sample.csv"
      }
    })
    assert epr.find_by_name("ACADEMY 20").is_a?(EconomicProfile)
  end

  def test_it_can_estimate_median_household_income

  # .estimated_median_household_income_in_year(year)
  end

end
