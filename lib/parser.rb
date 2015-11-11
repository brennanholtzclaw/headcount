require 'csv'
require 'pry'
require_relative 'kindergarten_participation'

class Parser
  attr_reader :data_location, :file, :extracted_data, :kg_participation

  def initialize(file)
    @file = file
  end

  def read_file(file)
    # Produces {"Colorado"=>{"2007"=>"0.39465", "2006"=>"0.33677", "2005"=>"0.27807", "2004"=>"0.24014", "2008"=>"0.5357", "2009"=>"0.598", "2010"=>"0.64019", "2011"=>"0.672", "2012"=>"0.695", "2013"=>"0.70263", "2014"=>"0.74118"}, "ACADEMY 20"=>{"2007"=>"0.39159", "2006"=>"0.35364", "2005"=>"0.26709", "2004"=>"0.30201", "2008"=>"0.38456", "2009"=>"0.39", "2010"=>"0.43628", "2011"=>"0.489", "2012"=>"0.47883", "2013"=>"0.48774", "2014"=>"0.49022"}, "ADAMS COUNTY 14"=>{"2007"=>"0.30643", "2006"=>"0.29331", "2005"=>"0.3", "2004"=>"0.22797", "2008"=>"0.67331", "2009"=>"1", "2010"=>"1", "2011"=>"1", "2012"=>"1", "2013"=>"0.9983", "2014"=>"1"}, "ADAMS-ARAPAHOE 28J"=>{"2007"=>"0.47359", "2006"=>"0.37013", "2005"=>"0.20176", "2004"=>"0.17444", "2008"=>"0.47965", "2009"=>"0.73", "2010"=>"0.92209", "2011"=>"0.95", "2012"=>"0.97359", "2013"=>"0.9767", "2014"=>"0.97123"}}

    @kg_participation = {}

    CSV.open(file, headers: true).each do |data|
      if @kg_participation[data["Location"].downcase].nil?
        @kg_participation[data["Location"].downcase] = {data["TimeFrame"]=>data["Data"]}
      else
        @kg_participation[data["Location"].downcase][data["TimeFrame"]] = data["Data"]
      end
    end
  end


  # OLD_2
  # CSV.open(file, headers: true).each do |data|
  #   if @kg_participation[data["Location"].downcase].nil?
  #     @kg_participation[data["Location"].downcase] = {data["TimeFrame"]=>data["Data"]}
  #   else
  #     @kg_participation[data["Location"].downcase][data["TimeFrame"]] = data["Data"]
  #   end
  # end
  #
  # NEW_2
  # csv_readlines(concatenate_data)
  #
  # OLD_1
  # csv = CSV.open(@path, {:headers => true})
  # csv.readlines.each do |line|
  #   district = line["Location"].downcase
  #   @names[district] = Enrollment.new(parsed.pretty_data(district))
  #   # this :name => line["Location"], :data_label => :dataset will become (dataset)
  # end
  #
  # NEW_1
  # csv = csv_readlines(enrollment_instances)
  #
  # def csv_readlines(do_something)
  #   csv = CSV.open(@path, {:headers => true})
  #   csv.readlines.each do |line|
  #     do_something
  #   end
  # end
  #
  # def enrollment_instances
  #   district = line["Location"].downcase
  #   @names[district] = Enrollment.new(parsed.pretty_data(district))
  # end
  #
  # def concatenate_data
  #   if @kg_participation[data["Location"].downcase].nil?
  #     @kg_participation[data["Location"].downcase] = {data["TimeFrame"]=>data["Data"]}
  #   else
  #     @kg_participation[data["Location"].downcase][data["TimeFrame"]] = data["Data"]
  #   end
  # end


  def pretty_data(district)
    # PRODUCES {:name=>"ACADEMY 20", :kindergarten_participation=>{"2007"=>"0.39159", "2006"=>"0.35364", "2005"=>"0.26709", "2004"=>"0.30201", "2008"=>"0.38456", "2009"=>"0.39", "2010"=>"0.43628", "2011"=>"0.489", "2012"=>"0.47883", "2013"=>"0.48774", "2014"=>"0.49022"}}
    pretty = {}
    pretty = {name: district.upcase, kindergarten_participation: @kg_participation[district.downcase]}
    puts pretty
  end

  def dataset_label
    "kindergarten_participation"
  end
end

parsed = Parser.new('./test/data/kindergarten_enrollment_sample.csv')
parsed.read_file('./test/data/kindergarten_enrollment_sample.csv')
parsed.pretty_data("Academy 20")
