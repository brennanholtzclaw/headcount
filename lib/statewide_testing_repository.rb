require 'csv'
require 'pry'
require_relative 'statewide_testing_parser'
require_relative 'master_parser'
require_relative 'statewide_test'

class StatewideTestRepository
attr_reader :statewide_testing, :location, :parser, :filepath

  def load_data(filepath)
    @filepath = filepath
    @statewide_testing = {}
    @parser = StatewideTestParser.new

    store_testing_instances
  end

  def store_testing_instances
    MasterParser.all_uniq_names(@filepath,:statewide_testing).each do |name|
      @statewide_testing[name] = StatewideTest.new(@parser.find_district_data_in_mult_files(name,@filepath))
    end
  end

  def find_by_name(district)
    if @statewide_testing.include?(district.upcase)
      @statewide_testing[district.upcase]
    end
  end

end