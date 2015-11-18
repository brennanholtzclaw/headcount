require 'pry'

class StatewideTest
  attr_reader :data

  def initialize(data)
    @data = data
  end

  def proficient_by_grade(grade)
    if grade == 3
      data[:third_grade]
    elsif grade == 8
      data[:eighth_grade]
    else
      raise UnknownDataError
    end
  end
end