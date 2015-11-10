#def find_by_name
####case insensitive search(downcase)

#def find_all_matching
####case insensitive search(downcase)

#def load_data( accept :symbol => value(file))

##needs to parse out name of district and create objects for each

# require_relative 'enrollment_repository'
# require_relative 'kindergarten_parser'
require './lib/district'
require 'csv'
require 'pry'

class DistrictRepository
  attr_reader :district, :years, :data_format, :data
  attr_accessor :district_repo

  def initialize
    @district_repo = {}
  end

  def load_data(filepath)
    CSV.open(filepath, headers: true).each do |data|
      # binding.pry
      row_data = {district:     data["Location"],
                  years:        data["TimeFrame"],
                  data_format:  data["DataFormat"],
                  data:         data["Data"]}

      @district_repo[data["Location"]] = District.new(row_data)
    end
  end
end
