class District
  attr_reader :district

  def initialize(data = {})
    @district = data
  end

  def name
    @district[:district].upcase
  end

end