class District
  attr_reader :district

  def initialize(data = {})
    @district = data
  end

  def name
    @district[:district].upcase
  end

  def years
    @district[:years]
  end

  def data_format
    @district[:data_format]
  end

  def data
    @district[:data]
  end

end
