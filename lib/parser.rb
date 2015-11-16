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

  def initialize(hash)
    @label_handle_hash = hash
  end

  def read_file(filepath)
    @kg_participation = {}
    @csv = FileIO.get_data(filepath)

    flatten_data
  end

  def read_files_and_returns_1_districts_data_for_multiple_files(district,filepath)
    @parser_data = {}

    filepath[:enrollment].each do |label, file|
      a = reads_file_and_returns_1_districts_data_for_one_file(district,label,file)

      if @parser_data == {}
        @parser_data = a
      else
        @parser_data[a[district.downcase].keys[0]] = a[district.downcase][label]
      end
        # key = dataset_name
        # value = hash of data
      # binding.pry
    end
    @parser_data
  end


  def reads_file_and_returns_1_districts_data_for_one_file(district,label,file)
    csv = FileIO.get_data(file)
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
#

# @parser_data ={}
# {:kindergarten => {"colorado"=>{2010=>0.436, 2011=>0.489, 2012=>0.479, 2013=>0.488, 2014=>0.49}
#   "Academy 20"=>{2010=>0.436, 2011=>0.489, 2012=>0.479, 2013=>0.488, 2014=>0.49},...}

#
# grab the key from the pair and set that as an instance variable
# pass the filepath to fileIO to do the reading
#   put that data into a hash for the above ivar
#
#     loop do
#       @kg_participation = {}
#       @csv = FileIO.get_data(filepath)
#       flatten_data
#     end
#   end



# 1. define an instance var to hold formatted data from dataset
# 2. retrieve data handle from fileIO
#     NEW: work from a list of label:extensions, and return
#
# 3. read handle and shovel data into instance variable
#
  def flatten_data
    # binding.pry
    @csv.readlines.each do |data|
      if @kg_participation[data["Location"].downcase].nil?
        @kg_participation[data["Location"].downcase] = {data["TimeFrame"].to_i => data["Data"].to_f.round(3)}

      else
        @kg_participation[data["Location"].downcase][data["TimeFrame"].to_i] = data["Data"].to_f.round(3)
      end
    end
    binding.pry
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
