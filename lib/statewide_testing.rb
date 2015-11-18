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
      raise "UnknownDataError",
      "#{grade} is not in our list of files."
    end
  end

  def all_race_file_years
    race_files = [:math, :reading, :writing]
    years = race_files.map do |file_symbol|
      @data[file_symbol].map do |keys, value|
        value.keys
      end
    end
    years.flatten.uniq
  end

  def race_file_scores(race, year)
    races = { :asian => "Asian",
              :black => "Black",
              :pacific_islander => "Hawaiian/Pacific Islander",
              :hispanic => "Hispanic",
              :native_american => "Native American",
              :two_or_more => "Two or More",
              :white => "White"}

    if races[race]
      race = races[race]
    else
      raise "UnknownRaceError"
    end

    scores = {}
    race_files = [:math, :reading, :writing]

    race_files.each do |symbol|
      scores[symbol] = @data[symbol][race][year]
    end
    scores
  end

  def proficient_by_race_or_ethnicity(race)
    years = all_race_file_years
    race_data = {}

    years.each do |year|
      race_data[year] = race_file_scores(race, year)
    end
    race_data
  end

  def proficient_for_subject_by_grade_in_year(subject, grade, year)
    grades = {3 => :third_grade, 8 => :eighth_grade}
    subjects = { :math => "Math",
              :reading => "Reading",
              :writing => "Writing"}

    @data[grades[grade]][year][subjects[subject]]
  end

  def proficient_for_subject_by_race_in_year(subject, race, year)
    races = { :asian => "Asian",
              :black => "Black",
              :pacific_islander => "Hawaiian/Pacific Islander",
              :hispanic => "Hispanic",
              :native_american => "Native American",
              :two_or_more => "Two or More",
              :white => "White"}

    @data[subject][races[race]][year]
  end
end
