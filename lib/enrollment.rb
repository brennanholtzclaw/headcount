class Enrollment
  attr_reader :data

  def initialize(data)
    @data = data
  end

  def kindergarten_participation_by_year
    ## returns hash with percentage for all years in data
  end

  def kindergarten_participation_in_year(year)
    ##returns nil if given unknown year
    ##returns floatnum for percentage
  end
  
end

