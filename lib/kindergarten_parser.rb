require 'pry'
require 'csv'

class KindergartenParser
  @districts = {}

  def parse(file)
    lines = CSV.readlines("#{file}", headers: true)
    lines.each do |row|
      @districts[row[:location]]
    end
    @districts
  end
end

pars = KindergartenParser.new.parse("./data/Kindergartners in full-day program.csv")

puts pars
