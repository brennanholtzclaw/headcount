require_relative 'enrollment_repository'

class Enrollment
  attr_reader :data, :name, :kindergarten_participation

  def initialize(all_data)
    @data = all_data[:data]
    @kindergarten_participation = all_data[:data][:kindergarten] if all_data[:data] && all_data[:data][:kindergarten]
    @kindergarten_participation = all_data[:kindergarten_participation] if all_data[:kindergarten_participation]
    @name = all_data[:name]
  end

  def kindergarten_participation_by_year
    @kindergarten_participation
  end

  def kindergarten_participation_in_year(year)
    @kindergarten_participation[year]
    # data[:kindergarten_partipation][year]
  end

  def graduation_rate_by_year
    data[:high_school_graduation]
 end

 def graduation_rate_in_year(year)
   data[:high_school_graduation][year]
 end

end

