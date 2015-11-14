require 'csv'
require 'pry'
require_relative 'enrollment_repository'
require_relative 'file_io'

class Parser
  attr_reader :data_location, :file, :extracted_data, :kg_participation, :district

  def read_file(filepath)
    @kg_participation = {}
    @csv = FileIO.get_data(filepath)

    flatten_data
  end

  def flatten_data
    @csv.readlines.each do |data|
      if @kg_participation[data["Location"].downcase].nil?
        @kg_participation[data["Location"].downcase] = {data["TimeFrame"].to_i => data["Data"].to_f.round(3)}

      else
        @kg_participation[data["Location"].downcase][data["TimeFrame"].to_i] = data["Data"].to_f.round(3)
      end
    end
  end

  def dataset_label
    "kindergarten_participation"
  end

  def all_data(district)
    pretty = {}
    pretty = {:name => district.upcase, :kindergarten_participation => @kg_participation[district.downcase]}
  end

end