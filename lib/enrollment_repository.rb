require 'csv'
require 'pry'
require_relative 'enrollment'
require_relative 'parser'

class EnrollmentRepository
  attr_reader :enrollments, :location, :parser, :filepath

  def load_data(filepath)
    @filepath = filepath
    @enrollments = {}
    @parser = Parser.new
    @parser.read_file(filepath)

    store_enrollment_instances
  end

  def store_enrollment_instances
    FileIO.get_data(@filepath).each do |line|
      district = line["Location"].downcase
      if @enrollments[line["Location"].downcase].nil?
        @enrollments[district] = Enrollment.new(@parser.pretty_data(district))
      end
    end
  end

  def find_by_name(district)
    if @enrollments.include?(district.downcase)
      @enrollments[district.downcase]
    end
  end
end