require 'csv'
require 'pry'
require_relative 'enrollment'
require_relative 'parser'
require_relative 'master_parser'

class EnrollmentRepository
  attr_reader :enrollments, :location, :parser, :filepath

  def load_data(filepath)
    @filepath = filepath[:enrollment]
    @enrollments = {}
    @parser = Parser.new
    @parser.read_file(@filepath)

    store_enrollment_instances
  end

  def store_enrollment_instances
    @enrollment_data = FileIO.get_data(@filepath)

    @instantiation_data = @enrollment_data

    MasterParser.names(@enrollment_data).each do |name|

      district = name.downcase

      @enrollments[district] = Enrollment.new(@parser.all_data(district))
    end
  end

# MasterParser.flattened_data(@enrollment_data,district)

  def find_by_name(district)
    if @enrollments.include?(district.downcase)
      @enrollments[district.downcase]
    end
  end

end