require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/district'

class DistrictTest < Minitest::Test

  def test_sets_upcased_name_of_district
    dist1 = District.new(district: "denver")
    dist2 = District.new(district: "academy20")

    refute_equal "denver",    dist1.name
    assert_equal "DENVER",    dist1.name
    assert_equal "ACADEMY20", dist2.name
  end

end
