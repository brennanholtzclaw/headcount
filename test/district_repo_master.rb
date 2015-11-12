require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/hc_analyst'

class HeadCountAnalystTest < Minitest::Test

  def test_it_accepts_district_repository
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./test/district_test_fixture.csv"
      }
    })
    hca = HeadCountAnalyst.new(dr)
    assert hca.master_repo
    # assert_equal 0, hca.master_repo
  end

  def test_it_finds_a_districts_enrollment_numbers
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./test/district_test_fixture.csv"
      }
    })
    hca = HeadCountAnalyst.new(dr)

    expected = {"2010"=>0.436, "2011"=>0.489, "2012"=>0.479, "2013"=>0.488, "2014"=>0.49}

    assert_equal expected, hca.find_all_data(dataset, district)

  end
end


# ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'COLORADO') # => 0.766
# average of Academy 20 kg participation
  # # find hash of Academy 20's kindergarten_participation_by_year
  #   @dr.er.enrollments
  # take average of all those values
