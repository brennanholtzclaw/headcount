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

# <Enrollment:0xXXXXXX @data={:name=>"COLORADO", :kindergarten_participation=>{"2007"=>"0.39465", "2006"=>"0.33677", "2005"=>"0.27807", "2004"=>"0.24014", "2008"=>"0.5357", "2009"=>"0.598", "2010"=>"0.64019", "2011"=>"0.672", "2012"=>"0.695", "2013"=>"0.70263", "2014"=>"0.74118"}}>

#TODO Return 3-digit floatnum instead of string