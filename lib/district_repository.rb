#def find_by_name
####case insensitive search(downcase)

#def find_all_matching
####case insensitive search(downcase)

#def load_data( accept :symbol => value(file))

##needs to parse out name of district and create objects for each

# require_relative 'enrollment_repository'
# require_relative 'kindergarten_parser'
require './lib/district'  # ~> LoadError: cannot load such file -- ./lib/district
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
      row_data = {district:     data["Location"],
                  years:        data["TimeFrame"],
                  data_format:  data["DataFormat"],
                  data:         data["Data"]}

      @district_repo[data["Location"]] = District.new(row_data)
    end
  end

  def find_by_name(district_name)
    if @district_repo.include?(district_name.upcase)
      @district_repo[district_name.upcase]
      # @district_repo.select {|k, v| k == district_name.upcase}
    else
      nil #is there an enumerable that returns nil?
    end
  end

  def find_all_matching(district_name)
     @district_repo.keys.select {|dist| dist.include?(district_name.upcase)}
  end

  def find_all
    @district_repo.keys
  end
end



#one person merges branch into master
#other person pulls master into their branch
# git pull -r origin master
#other person merges branch into master
