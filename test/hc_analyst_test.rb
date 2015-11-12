require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/hc_analyst'

class HeadcountAnalystTest < Minitest::Test
  attr_reader :dr, :ha

  def create_district_repo_and_hc_analyst
    @dr = DistrictRepository.new
    @dr.load_data( {:enrollment => {
                    :kindergarten => "./test/data/district_test_fixture.csv"}})
    @ha = HeadcountAnalyst.new(dr)
  end

  def test_it_accepts_district_repository
    create_district_repo_and_hc_analyst

    assert ha.master_repo
  end

  def test_it_finds_a_districts_enrollment_numbers
    create_district_repo_and_hc_analyst

    expected = {"2010"=>0.436, "2011"=>0.489, "2012"=>0.479, "2013"=>0.488, "2014"=>0.49}

    assert_equal expected, ha.find_all_data("Academy 20", :kindergarten_participation)
  end

  def test_average_finds_average_of_all_years_available_in_data
    create_district_repo_and_hc_analyst

    assert_equal 0.476, ha.average("academy 20", :kindergarten_participation)
    assert_equal 0.69, ha.average("colorado", :kindergarten_participation)
    assert_equal 1.0, ha.average("adams county 14", :kindergarten_participation)
  end

  def test_average_finds_variation_between_two_districts
    create_district_repo_and_hc_analyst

    assert_equal 0.69, ha.kindergarten_participation_rate_variation("academy 20", :against => 'COLORADO')

    assert_equal 2.101, ha.kindergarten_participation_rate_variation('Adams County 14', :against => 'academy 20')
  end

  def test_finds_years_two_districts_have_data
    create_district_repo_and_hc_analyst

    assert_equal %w(2010 2011 2012 2013 2014), ha.years_with_data("academy 20", "colorado")
  end

  def test_finds_rate_in_years_two_districts_have_data
    create_district_repo_and_hc_analyst

    expected = {"2010"=>2.294, "2011"=>2.045, "2012"=>2.088, "2013"=>2.045, "2014"=>2.041}

    assert_equal expected, ha.kindergarten_participation_rate_variation_trend('Adams County 14', :against => 'academy 20')
  end

end
