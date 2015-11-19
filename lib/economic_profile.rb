require 'pry'

class EconomicProfile
  attr_reader :data
  attr_accessor

  def initialize(data)
    @data = data
  end

  def estimated_median_household_income_in_year(year)
    counter = 1
    list = []
    @data[:median_household_income].each do |top, bottom|

      if (top[0]..top[1]).include?(year)
        list << bottom
        counter += 1
      end
    end
    list.reduce(:+)/list.size
  end
end

class UnknownDataError < ArgumentError
end
