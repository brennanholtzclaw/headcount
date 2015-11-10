#def find_by_name
####case insensitive search(downcase)

#def find_all_matching
####case insensitive search(downcase)

#def load_data( accept :symbol => value(file))

##needs to parse out name of district and create objects for each

require_relative 'district'
# require_relative 'enrollment_repository'
require_relative 'kindergarten_parser'
require 'pry'

class DistrictRepository
  attr_reader :districts
  attr_accessor :enrollment_repo

  def initialize
    @districts = {}
    @enrollment_repo = EnrollmentRepository.new
  end

  def load_data
    data = KindergartenParser.new#(call method or parse automatically?)
    data.keys.each do |district|
      @districts[district.upcase] = District.new(name: district)
      @districts[district.upcase] = @enrollment_repo.enrollments[district]
    end
  end
