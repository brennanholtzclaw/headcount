require './test/test_helper'
require './lib/master_parser'
require './lib/file_io'
require 'pry'

class MasterParserTest < Minitest::Test

  def setup
    @fixture_data = FileIO.get_data({:enrollment => {
                   :kindergarten => "./test/data/district_test_fixture.csv"}})
  end

  def test_it_returns_all_unique_districts
    assert_equal 14, MasterParser.names(@fixture_data).length
  end

  def test_it_returns_all_unique_years
    assert_equal 5, MasterParser.years(@fixture_data).length
  end

  def test_it_returns_all_unique_values
    # skip
    assert_equal 34, MasterParser.values(@fixture_data).length
  end


  def test_it_returns_related_data_for_a_single_district
    expected = {2010 => 0.436, 2011 => 0.489, 2012 => 0.479, 2013 => 0.488, 2014 => 0.490}
    assert_equal expected, MasterParser.flattened_data(@fixture_data,"Academy 20")
  end

end


# if I give it one row from a file, I want it to return name
# if I give it one row from a file, I want it to return year
# if I give it one row from a file, I want it to return dataformat
# if I give it one row from a file, I want it to return data
#
# if i give it a whole file and district, I want it to return data for the range of years available
#
# if i give it a whole file and year, I want it to return data for the hash of districts with data in that year available
