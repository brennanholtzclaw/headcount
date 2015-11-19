require_relative 'enrollment_repository'

class Enrollment
  attr_reader :data

  def initialize(data)
    @data = data
  end

  def kindergarten_participation_by_year
    data[:kindergarten_participation]
  end

  def kindergarten_participation_in_year(year)
    data[:kindergarten_participation][year]
  end

  def graduation_rate_by_year
   data[data.keys[0]][:high_school_graduation]
 end

 def graduation_rate_in_year(year)
   data[data.keys[0]][:high_school_graduation][year]
 end

end

