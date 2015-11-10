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
require './lib/district_repository'
require 'csv'


class DistrictRepositoryTest < Minitest::Test

def test_it_can_load_data
  dr = DistrictRepository.new
  dr.load_data('./test/district_test_fixture.csv')
  #just don't break#
end

def test_load_data_creates_hash_for_listed_districts
  dr = DistrictRepository.new
  dr.load_data('./test/district_test_fixture.csv')

  assert dr.district_repo.length > 2
  assert_equal 14, dr.district_repo.length
  binding.pry
end

def test_it_can_find_by_name

end

def test_find_all_lists_array_of_unique_districts
end

def test_find_all_lists_empty_array_if_no_districts_found
end

end
