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
end