#test_name_returns_string
##should return an upcased string that is the name of the district
##
require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/district'
# require 'test_fixtures'


class DistrictTest < Minitest::Test


  def test_sets_upcased_name_of_district
    dist1 = District.new(name: "denver")
    dist2 = District.new(name: "academy20")

    refute_equal "denver",    dist1.name
    assert_equal "DENVER",    dist1.name
    assert_equal "ACADEMY20", dist2.name
  end

end
