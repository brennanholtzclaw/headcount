require 'csv'
require 'pry'
require_relative 'kindergarten_participation'

class Parser
  attr_reader :data_location, :file, :extracted_data, :kg_participation

  def read_file(file)
    @kg_participation = {}
    @csv = CSV.open(file, headers: true)

    flatten_data
  end

  def flatten_data
    @csv.readlines.each do |data|
      if @kg_participation[data["Location"].downcase].nil?
        @kg_participation[data["Location"].downcase] = {data["TimeFrame"]=>data["Data"]}
      else
        @kg_participation[data["Location"].downcase][data["TimeFrame"]] = data["Data"]
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