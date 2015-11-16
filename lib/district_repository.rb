require './lib/district'
require './lib/enrollment_repository'
require './lib/file_io'
require 'csv'
require 'pry'

class DistrictRepository
  attr_reader :nested_filepaths
  attr_accessor :district_repo, :er

  def initialize
    @district_repo = {}
  end

  def load_data(nested_filepaths)
    @nested_filepaths = nested_filepaths
    data_handles = FileIO.get_data(nested_filepaths)
    all_names = MasterParser.all_uniq_names(nested_filepaths)

    populate_district_repo(all_names)

    instantiate_enrollment_repo(nested_filepaths)
  end

  def populate_district_repo(all_names)
    all_names = all_names.map(&:upcase)
    all_names.each do |name|
      add_new_instance(name)
    end
  end

  def add_new_instance(name)
    @district_repo[name] = District.new(name)
  end

  def instantiate_enrollment_repo(nested_filepaths)
    if nested_filepaths[:enrollment]
      @er = EnrollmentRepository.new
      @er.load_data(nested_filepaths)
    else
      nil
    end
  end

  def find_by_name(name)
    if @district_repo.include?(name.upcase)
        @district_repo[name.upcase]
    else
      nil
    end
  end

  def find_all_matching(name)
     @district_repo.keys.select {|dist| dist.include?(name.upcase)}
  end

  def find_all
    @district_repo.keys
  end
end
