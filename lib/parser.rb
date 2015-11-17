require 'csv'
require 'pry'
require_relative 'enrollment_repository'
require_relative 'file_io'

class Parser
  attr_reader :data_location,
  :file,
  :extracted_data,
  :kg_participation,
  :district,
  :label_handle_hash,
  :parser_data

  def initialize(hash=nil)
    @label_handle_hash = hash
  end

  def find_district_data_in_mult_files(district,filepath)
    @parser_data = {}

    filepath[:enrollment].each do |label_x, file|
      a = reads_file_and_returns_1_districts_data_for_one_file(district,label_x,file)

      if a == {}
      elsif @parser_data == {}
        @parser_data = a
      else
        @parser_data[district.downcase][a[district.downcase].keys[0]] = a[district.downcase].values[0]
      end
    end
    @parser_data
  end

  def reads_file_and_returns_1_districts_data_for_one_file(district,label,filepath)
    csv = FileIO.get_data(filepath)
    data_group = {}

    csv.readlines.each do |data|
      if data["Location"].downcase == district.downcase
        if data_group[district.downcase].nil?
          data_group[district.downcase] = {label => {data["TimeFrame"].to_i => data["Data"].to_f.round(3)}}
        else
          data_group[district.downcase][label][data["TimeFrame"].to_i] = data["Data"].to_f.round(3)
        end
      end
    end
    data_group
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

  def flatten_highschool_grad_dataset
    @csv.readlines.each do |data|
      if @high_school_graduation[data["Location"].downcase].nil?
        @high_school_graduation[data["Location"].downcase] = {data["TimeFrame"].to_i => data["Data"].to_f.round(3)}

      else
        @high_school_graduation[data["Location"].downcase][data["TimeFrame"].to_i] = data["Data"].to_f.round(3)
      end
    end
  end


  def dataset_label
    "kindergarten_participation"
  end

  def all_data(district)
      @label_handle_hash
    pretty = {}
    pretty = {:name => district.upcase, :kindergarten_participation => @kg_participation[district.downcase]}
  end

end
