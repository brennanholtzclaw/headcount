require_relative 'district_repository'

class District
  attr_reader :district, :enrollment, :testing_data

  def initialize(data)
    @district = data[:name]

    if !data[:data].nil?
      @enrollment = data[:data][:enrollment]
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
