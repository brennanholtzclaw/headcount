#def name

#.to_s.upcase

# require './lib/district_repository'
# require './lib/kindergarten_parser'

class District
  attr_reader :district

  def initialize(data = {})
    @district = data
    # @district[:district] = @district[:district].upcase
    #
  end

  def name
    @district[:district]
  end

end
