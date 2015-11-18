require_relative 'district'
require_relative 'enrollment_repository'
require_relative 'file_io'
require_relative 'statewide_testing_repository'
require 'csv'
require 'pry'

class DistrictRepository
  attr_reader :nested_filepaths
  attr_accessor :district_repo, :er, :str

  def initialize
    @district_repo = {}
  end

  def load_data(nested_filepaths)
    @nested_filepaths = nested_filepaths
    all_names = MasterParser.all_uniq_names(nested_filepaths)

    instantiate_enrollment_repo(nested_filepaths) if nested_filepaths[:enrollment]

    instantiate_statewide_testing_repo(nested_filepaths) if nested_filepaths[:statewide_testing]

    populate_district_repo(all_names)
  end

  def populate_district_repo(all_names)
    all_names = all_names.map(&:upcase)
    all_names.each do |name|
      add_new_instance(name)
    end
  end

  def add_new_instance(name)
    @district_repo[name] = District.new({:name => name, :data => districts_data(name)})
  end

  def districts_data(district)
    d_data = {}
    d_data[:statewide_testing] = @str.statewide_testing[district.downcase] if @str
    d_data[:enrollment] = @er.enrollments[district.downcase] if @er
    d_data
  end

  def instantiate_enrollment_repo(nested_filepaths)
    if nested_filepaths[:enrollment]
      @er = EnrollmentRepository.new
      @er.load_data(nested_filepaths)
    else
      nil
    end
  end

  def instantiate_statewide_testing_repo(nested_filepaths)
    if nested_filepaths[:statewide_testing]
      @str = StatewideTestRepository.new
      @str.load_data(nested_filepaths)
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
