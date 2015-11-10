require 'csv'
require 'pry'
require '/Users/elizabethsebian/turing/1module/projects/headcount/lib/enrollment.rb'

class EnrollmentRepository
  attr_reader :file, :names

  def load_data
    @names = {}

    kindergarten = CSV.open("/Users/elizabethsebian/turing/1module/projects/headcount/data/Kindergartners in full-day program.csv", {:headers => true})

    kindergarten.readlines.each do |line|
      @names[line["Location"].downcase] = Enrollment.new(line["Location"])
    end

  end

  def find_by_name(district)
    if @names.include?(district.downcase)
      @names[district.downcase]
    end
  end

end

er = EnrollmentRepository.new
er.load_data
puts er.names
puts er.find_by_name("Academy 20")

# er.load_data({
#   :enrollment => {
#     :kindergarten => "./data/Kindergartners in full-day program.csv"
#   }
# })
# enrollment = er.find_by_name("ACADEMY 20")
# => <Enrollment>

# TODO: load from given filepath
# TODO: add header_converter to CSV.open