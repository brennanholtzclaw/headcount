require './lib/district'
require './lib/enrollment_repository'
require './lib/file_io'
require 'csv'
require 'pry'

class DistrictRepository
  attr_reader :district, :years, :data_format, :data, :filepath
  attr_accessor :district_repo, :enrollment_repo, :er

  def initialize
    @district_repo = {}
  end

  def load_data(filepath)
    @filepath = filepath

    @district_data = FileIO.get_data(filepath)

    MasterParser.names(@district_data).each do |name|
      add_new_instance(name)
    end

    make_enrollment_repo(filepath)
  end

  def make_enrollment_repo(filepath)
    if filepath.fetch(:enrollment)
      @er = EnrollmentRepository.new
      @er.load_data(filepath)
    end
  end

  def add_new_instance(name)
    @district_repo[name] = District.new(name)
  end

  def find_by_name(district_name)
    if @district_repo.include?(district_name.upcase)
        @district_repo[district_name.upcase]
    else
      nil
    end
  end

  def find_all_matching(district_name)
     @district_repo.keys.select {|dist| dist.include?(district_name.upcase)}
  end

  def find_all
    @district_repo.keys
  end
end
