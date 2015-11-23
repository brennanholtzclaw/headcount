require_relative 'district'
require_relative 'enrollment_repository'
require_relative 'file_io'
require_relative 'statewide_testing_repository'
require 'csv'
require 'pry'

class DistrictRepository
  attr_reader :district_repo, :er, :str

  def initialize
    @district_repo = {}
  end

  def find_unique_district_names(nested_filepaths)
    MasterParser.all_uniq_names(nested_filepaths)
  end

  def load_data(nested_filepaths)
    all_names = find_unique_district_names(nested_filepaths)
    create_child_repositories(nested_filepaths)
    populate_district_repo(all_names)
  end

  def create_child_repositories(nested_filepaths)
    create_e_repo(nested_filepaths) if nested_filepaths[:enrollment]
    create_st_repo(nested_filepaths) if nested_filepaths[:statewide_testing]
    create_ep_repo(nested_filepaths) if nested_filepaths[:economic_profile]
  end

  def populate_district_repo(all_names)
    all_names.each { |name| add_new_instance(name) }
  end

  def add_new_instance(name)
    @district_repo[name] = District.new(districts_data(name))
  end

  def districts_data(name)
    d_data = {:name => name, :data => {}}
    d_data[:data][:enrollment] = @er.enrollments[name] if @er
    d_data[:data][:statewide_testing] = @str.statewide_testing[name] if @str
    d_data
  end

  def create_e_repo(nested_filepaths)
    @er = EnrollmentRepository.new
    @er.load_data(nested_filepaths)
  end

  def create_st_repo(nested_filepaths)
    @str = StatewideTestRepository.new
    @str.load_data(nested_filepaths)
  end

  def create_ep_repo(nested_filepaths)
    @ep = EconomicProfileRepository.new
    @ep.load_data(nested_filepaths)
  end

  def find_by_name(name)
    @district_repo[name.upcase] if @district_repo.include?(name.upcase)
  end

  def find_all_matching(name)
     @district_repo.keys.select {|dist| dist.include?(name.upcase)}
  end

  def find_all
    @district_repo.keys
  end
end
