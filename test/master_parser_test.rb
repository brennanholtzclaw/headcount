require './test/test_helper'
require './lib/master_parser'
require './lib/file_io'

class MasterParserTest < Minitest::Test

  def setup
    @fixture_data = FileIO.get_data({:enrollment => {
                   :kindergarten => "./test/data/district_test_fixture.csv"}})
    @fixture_line = @fixture_data.readline
  end

  def test_it_finds_district_in_single_line
    assert_equal "Colorado", MasterParser.district(@fixture_line)
    # <CSV::Row "Location":"Colorado" "TimeFrame":"2010" "DataFormat":"Percent" "Data":"0.64019">
  end
end






# MasterParser
# if I give it one row from a file, I want it to return name
# if I give it one row from a file, I want it to return year
# if I give it one row from a file, I want it to return dataformat
# if I give it one row from a file, I want it to return data
#
# if i give it a whole file and district, I want it to return data for the range of years available
#
# if i give it a whole file and year, I want it to return data for the hash of districts with data in that year available
