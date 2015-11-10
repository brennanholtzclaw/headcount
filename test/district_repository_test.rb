#test_it_has_find_by_name
####returns_nil or instance of District
####case insensitive search(downcase)

#test_it_has_find_all_matching_method
####returns an empty array or array of dists. that match

#test_it_can_load_data

#test load_data_creates_key_value_pair_for_all_districts
###will need parser here
###values are instances of district class
require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/district_repository'
# require 'test_fixtures.csv'

class DistrictRepositoryTest < Minitest::Test

def test_it_can_load_data
end

def test_load_data_creates_hash_for_listed_districts
end

def test_it_can_find_by_name
end

def test_find_all_lists_array_of_unique_districts
end

def test_find_all_lists_empty_array_if_no_districts_found
end

end
