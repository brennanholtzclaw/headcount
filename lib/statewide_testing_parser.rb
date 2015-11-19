require 'csv'
require 'pry'
require_relative 'file_io'

class StatewideTestParser
  attr_reader :parser_data, :race_files, :grade_files

  def initialize
    @race_files = [:reading, :writing, :math]
    @grade_files = [:third_grade, :eighth_grade]
  end

  def find_district_data_in_mult_files(district,filepath)
    @parser_data = {}

    filepath[:statewide_testing].each do |label, file|
      if @grade_files.include?(label)
        a = reads_file_and_returns_1_districts_data_for_one_file(district,label,file)
      elsif @race_files.include?(label)
        a = read_race_files(district,label,file)
      end

      if a == {}
      elsif @parser_data == {}
        @parser_data = a
      else
        @parser_data[label] = a[label]
      end
    end
    @parser_data
  end

  def reads_file_and_returns_1_districts_data_for_one_file(district,label,filepath)
    csv = FileIO.get_data(filepath)
    testing_group = {}

    csv.readlines.each do |data|
      if data["Location"].downcase == district.downcase


        if testing_group[label].nil?
            testing_group = {label => {data["TimeFrame"].to_i => {data["Score"].downcase.to_sym =>data["Data"].to_f.round(3)}}}
        else
          if testing_group[label][data["TimeFrame"].to_i].nil?
            testing_group[label][data["TimeFrame"].to_i] = {data["Score"].downcase.to_sym =>data["Data"].to_f.round(3)}
          else
            testing_group[label][data["TimeFrame"].to_i][data["Score"].downcase.to_sym] = data["Data"].to_f.round(3)
          end
        end
      end
    end
    testing_group
  end

  def read_race_files(district,label,filepath)
    csv = FileIO.get_data(filepath)
    testing_group = {}

    csv.readlines.each do |data|
      race_to_symbol = data["Race Ethnicity"].gsub(" ","_").gsub("/", "_").downcase.to_sym

      if data["Location"].downcase == district.downcase
        if testing_group[label].nil?

            testing_group = {label => {race_to_symbol => {data["TimeFrame"].to_i=>data["Data"].to_f.round(3)}}}
        else
          if testing_group[label][race_to_symbol].nil?
            testing_group[label][race_to_symbol] = {data["TimeFrame"].to_i=>data["Data"].to_f.round(3)}
          else
            testing_group[label][race_to_symbol][data["TimeFrame"].to_i] = data["Data"].to_f.round(3)
          end
        end
      end
    end
    testing_group
  end
end
