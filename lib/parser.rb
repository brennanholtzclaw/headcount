require 'csv'
require 'pry'
require_relative 'enrollment_repository'
require_relative 'file_io'

class Parser
  attr_reader :parser_data

  def find_district_data_in_mult_files(district,filepath)
    @parser_data = {}

    filepath[:enrollment].each do |label_x, file|
      a = reads_file_and_returns_1_districts_data_for_one_file(district,label_x,file)

      if a == {}
      elsif @parser_data == {}
        @parser_data = a
      else
        @parser_data[a.keys[0]] = a.values[0]
      end
    end
    @parser_data
  end

  def reads_file_and_returns_1_districts_data_for_one_file(district,label,filepath)
    csv = FileIO.get_data(filepath)
    data_group = {}

    csv.readlines.each do |data|
      if data["Location"].downcase == district.downcase
        if data_group[label].nil?
          data_group[label] = {data["TimeFrame"].to_i => data["Data"].to_f.round(3)}
        else
          data_group[label][data["TimeFrame"].to_i] = data["Data"].to_f.round(3)
        end
      end
    end
    data_group
  end
end

