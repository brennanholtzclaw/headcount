require 'csv'
require 'pry'
require_relative 'enrollment'
require_relative 'parser'

class EnrollmentRepository
  attr_reader :file, :names, :parser, :path_nest


  def load_data(path_nest)
    @path_nest = path_nest
    @path = path_nest.fetch(:enrollment).fetch(:kindergarten)
    @names = {}
    parser = Parser.new(@path)
    parser.read_file(@path)
    csv = CSV.open(@path, {:headers => true})

    csv.readlines.each do |line|
      district = line["Location"].downcase
      @names[district] = Enrollment.new(parser.pretty_data(district))
      # this :name => line["Location"], :data_label => :dataset will become (dataset)
    end
  end

  def find_by_name(district)
    if @names.include?(district.downcase)
      district_value = @names[district.downcase]
    end
    district_value
  end
end

# need to be able to pass new instance of enrollment a string of data from the given file (line 19)
# need to create another object I can reference to produce that string


er = EnrollmentRepository.new
er.load_data({
  :enrollment => {
    :kindergarten => "./test/data/kindergarten_enrollment_sample.csv"
  }
})
puts er.find_by_name("Academy 20")

# TODO: add header_converter to CSV.open
