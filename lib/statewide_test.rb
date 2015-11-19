require 'pry'

class StatewideTest
  attr_reader :data
  attr_accessor :race, :subject, :grade, :year

  def initialize(data)
    @data = data
  end

  def proficient_by_grade(grade)
    if grade == 3
      data[:third_grade]
    elsif grade == 8
      data[:eighth_grade]
    else
      raise "UnknownDataError" #{grade} is not in our list of files."
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

  def is_a_valid_year?(year)
    year_files = [:third_grade, :eighth_grade]
    years = year_files.map do |file_symbol|
      @data[file_symbol].keys
    end
    years.flatten.uniq
    if years.flatten.uniq.include?(year)
      @year = year
    else
      raise "UnknownDataError"
    end
  end

  def is_a_valid_race?(race)
    races = { :asian => "Asian", :black => "Black",
              :pacific_islander => "Hawaiian/Pacific Islander", :hispanic => "Hispanic",
              :native_american => "Native American", :two_or_more => "Two or More",
              :white => "White"}
    if races[race]
      @race = races[race]
      true
    else
      raise "UnknownRaceError"
    end
  end

  def is_a_valid_subject?(subject)
    subjects = { :math => "Math",
              :reading => "Reading",
              :writing => "Writing"}
    if subjects[subject]
      @subject = subjects[subject]
      true
    else
      raise "UnknownDataError"
    end
  end

  def is_a_valid_grade?(grade)
    grades = {3 => :third_grade, 8 => :eighth_grade}
    if grades[grade]
      @grade = grades[grade]
      true
    else
      raise "UnknownDataError"
    end
  end

  def race_file_scores(race, year)
    is_a_valid_race?(race)

    scores = {}
    race_files = [:math, :reading, :writing]

    race_files.each do |symbol|
      scores[symbol] = @data[symbol][@race][year]
    end
    scores
  end

  def proficient_by_race_or_ethnicity(race)
    years = all_race_file_years
    race_data = {}
    is_a_valid_race?(race)

    years.each do |year|
      race_data[year] = race_file_scores(race, year)
    end
    race_data
  end

  def proficient_for_subject_by_grade_in_year(subject, grade, year)
    is_a_valid_subject?(subject)
    is_a_valid_grade?(grade)
    is_a_valid_year?(year)

    @data[@grade][year][@subject]
  end

  def proficient_for_subject_by_race_in_year(subject, race, year)
    is_a_valid_race?(race)
    is_a_valid_year?(year)
    is_a_valid_subject?(subject)
    @data[subject][@race][@year]
  end

end
