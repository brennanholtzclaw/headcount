require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/district'

class DistrictTest < Minitest::Test

  def test_it_accepts_names_in_spec_format
    dist1 = District.new({:name => "denver"})
    dist2 = District.new({:name => "academy20"})

    refute_equal "denver",    dist1.name
    assert_equal "DENVER",    dist1.name
    assert_equal "ACADEMY20", dist2.name
  end
end
