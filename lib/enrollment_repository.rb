require 'csv'
require 'pry'
require_relative 'enrollment'
require_relative 'enrollment_parser'
require_relative 'master_parser'

class EnrollmentRepository
  attr_reader :enrollments, :location, :parser, :filepath

  def load_data(filepath)
    @filepath = filepath
    @enrollments = {}
    @parser = EnrollmentParser.new

    store_enrollment_instances
  end

  def store_enrollment_instances
    MasterParser.all_uniq_names(@filepath).each do |name|
      @enrollments[name] = Enrollment.new(:name=>name, :data=>@parser.find_district_data_in_mult_files(name,@filepath))
    end
  end

  def find_by_name(district)
    if @enrollments.include?(district.upcase)
      @enrollments[district.upcase]
    end
  end

end
