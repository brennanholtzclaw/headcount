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

  # District Repository
  # passes multiple sets of parsed data to enrollment instance
  # passes long, ugly, hashed-up, filepath to fileIO (maybe slightly simplified)
  # gets back a hash of label:handles (parser loves to accept this format)
  #
  # passes label=> handle to MasterPrser (ALL AT ONCE)
  # get back a array of unique names
  #
  # create an enrollment repo. Passes long, ugly, hashed-up file path to ER
  #
  # FileIO
  # produce a csv handle
  # return hash (label:handle} with just one or multiple pairs
  #
  #
  # Enrollment Repo
  # initialized with long, ugly, hashed-up, filepath
  # prepare label:handles hash with fileIO to send to parser
  # initialized with parser(label:handle hash)
  #
  # passes long, ugly, hashed-up, filepath to fileIO (maybe slightly simplified)
  # gets back a hash of label:handles (parser loves to accept this format)
  #
  # passes district_name to parser
  # receives pretty data from parser
  #
  # iterates through the loop of names,
  # sets name as key, instantiates Enrollment object with district’s pretty data
  #
  # Parser
  # accepts label: handle hash
  # prepares pretty data according to district name


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
