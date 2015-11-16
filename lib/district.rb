class District
  attr_reader :district

  def initialize(data = {})
    @district = data
  end

  def name
    @district[:name].upcase
  end

end