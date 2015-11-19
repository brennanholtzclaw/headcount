require_relative 'district_repository'

class District
  attr_reader :district, :enrollment_data, :testing_data, :enrollment

  def initialize(data = {})
    @district = data[:name]

    if !data[:data].nil?
      @enrollment_data = data[:data][:enrollment]
      @testing_data = data[:data][:statewide_testing]
    end
  end

  def enrollment
    @enrollment_data
  end

  def name
    @district.upcase
  end

  def statewide_test
    @testing_data
  end

end
