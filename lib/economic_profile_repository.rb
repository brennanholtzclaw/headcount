require 'csv'
require 'pry'
require_relative 'economic_profile_parser'
require_relative 'master_parser'
require_relative 'economic_profile'

class EconomicProfileRepository
attr_reader :economic_profile, :location, :parser, :filepath

  def load_data(filepath)
    @filepath = filepath
    @economic_profile = {}
    @parser = EconomicProfileParser.new

    store_testing_instances
  end

  def store_testing_instances
    MasterParser.all_uniq_names(@filepath,:economic_profile).each do |name|
      @economic_profile[name.downcase] = EconomicProfile.new(@parser.arrange_district_data(name,@filepath))
    end
  end

  def find_by_name(district)
    if @economic_profile.include?(district.downcase)
      @economic_profile[district.downcase]
    end
  end

end