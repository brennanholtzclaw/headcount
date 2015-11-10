#def name

#.to_s.upcase


class District
  attr_reader :name

  def initialize(name_hash)
    @name = name_hash[:name].upcase
  end

end
