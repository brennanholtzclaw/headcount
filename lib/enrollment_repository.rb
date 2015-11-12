require 'csv'
require 'pry'
require_relative 'enrollment'
require_relative 'parser'

class EnrollmentRepository
  attr_reader :enrollments, :location, :parser, :file_path

  def load_data(location)
    @file_path = location.fetch(:enrollment).fetch(:kindergarten)
    @enrollments = {}
    @parser = Parser.new
    @parser.read_file(file_path)
    @csv = CSV.open(file_path, {:headers => true})

    store_enrollment_instances
  end

  def store_enrollment_instances
    @csv.readlines.each do |line|
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