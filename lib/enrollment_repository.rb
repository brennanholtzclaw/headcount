require 'csv'
require 'pry'
require_relative 'enrollment'
require_relative 'parser'
require_relative 'master_parser'

class EnrollmentRepository
  attr_reader :enrollments, :location, :parser, :filepath

  def load_data(filepath)
    @filepath = filepath
    @enrollments = {}
    @parser = Parser.new

    store_enrollment_instances
  end

  def store_enrollment_instances
    MasterParser.all_uniq_names(@filepath).each do |name|
      @enrollments[name.downcase] = Enrollment.new(@parser.find_district_data_in_mult_files(name,@filepath))
    end
  end

  def find_by_name(district)
    if @enrollments.include?(district.downcase)
      @enrollments[district.downcase]
    end
  end

end