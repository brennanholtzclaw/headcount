require 'csv'
require 'pry'
require_relative 'kindergarten_participation'
require_relative 'enrollment_repository'

class Parser
  attr_reader :data_location, :file, :extracted_data, :kg_participation, :district

  def read_file(file)
    @kg_participation = {}
    @csv = CSV.open(file, headers: true)

    flatten_data
  end

  def flatten_data
    @csv.readlines.each do |data|
      if @kg_participation[data["Location"].downcase].nil?
        @kg_participation[data["Location"].downcase] = {data["TimeFrame"]=>data["Data"].to_f.round(3)}

      else
        @kg_participation[data["Location"].downcase][data["TimeFrame"]] = data["Data"].to_f.round(3)
      end
    end
  end

  def pretty_data(district)
    pretty = {}
    pretty = {name: district.upcase, kindergarten_participation: @kg_participation[district.downcase]}
  end

  def dataset_label
    "kindergarten_participation"
  end
end

# p = Parser.new
# p.read_file('./test/data/kindergarten_enrollment_sample.csv')
# puts p.pretty_data("colorado")

