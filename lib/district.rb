require './lib/district_repository'

class District
  attr_reader :district

  def initialize(data = {})
    # binding.pry
    @district = data[:name]

    if !data[:data].nil?
      @enrollment_data = data[:data][:enrollment]
      @testing_data = data[:data][:statewide_testing]
    end
  end

  def name
    @district.upcase
  end

  def statewide_test
    @testing_data
  end

end