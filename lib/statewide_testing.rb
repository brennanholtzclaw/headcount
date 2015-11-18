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
      raise "UnknownDataError"
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
    scores = {}
    race_files = [:math, :reading, :writing]

    race_files.each do |symbol|
      scores[symbol] = @data[symbol][race.to_s.capitalize][year]
    end
    scores
  end

  def proficient_by_race_or_ethnicity(race)
    all_race_file_years

  end
end

  # def test_it_finds_data_by_race
  #   st = setup_tests
  #   expected = {  2011 => {math: 0.816, reading: 0.897, writing: 0.826},
  #                 2012 => {math: 0.818, reading: 0.893, writing: 0.808},
  #                 2013 => {math: 0.805, reading: 0.901, writing: 0.810},
  #                 2014 => {math: 0.800, reading: 0.855, writing: 0.789}}
  #
  #   assert_equal expected, st.proficient_by_race_or_ethnicity(:asian)
  # end

  #   sort through @data and find the race (options) in each category.
  #   pull out the data FROM each category FOR each year in the data
  #   return a hash with years as keys pointing to a value that is a hash with subjects (math, writing...) as keys and the scores as values
  #       set each year in a top level hash whose value is another hash
  #         the nested hash has subjects (math, reading...) as keys and scores as values
  # end

#    :math=>
#  {"All Students"=>{2011=>0.68, 2012=>0.689, 2013=>0.697, 2014=>0.699},
#   "Asian"=>{2011=>0.817, 2012=>0.818, 2013=>0.805, 2014=>0.8},
#   "Black"=>{2011=>0.425, 2012=>0.425, 2013=>0.44, 2014=>0.421},
#   "Hawaiian/Pacific Islander"=>{2011=>0.569, 2012=>0.571, 2013=>0.683, 2014=>0.682},
#   "Hispanic"=>{2011=>0.568, 2012=>0.572, 2013=>0.588, 2014=>0.605},
#   "Native American"=>{2011=>0.614, 2012=>0.571, 2013=>0.593, 2014=>0.544},
#   "Two or more"=>{2011=>0.677, 2012=>0.69, 2013=>0.697, 2014=>0.693},
#   "White"=>{2011=>0.707, 2012=>0.714, 2013=>0.721, 2014=>0.723}},
# :writing=>
#  {"All Students"=>{2011=>0.719, 2012=>0.706, 2013=>0.72, 2014=>0.716},
#   "Asian"=>{2011=>0.827, 2012=>0.808, 2013=>0.811, 2014=>0.789},
#   "Black"=>{2011=>0.515, 2012=>0.504, 2013=>0.482, 2014=>0.519},
#   "Hawaiian/Pacific Islander"=>{2011=>0.726, 2012=>0.683, 2013=>0.717, 2014=>0.727},
#   "Hispanic"=>{2011=>0.607, 2012=>0.598, 2013=>0.623, 2014=>0.624},
#   "Native American"=>{2011=>0.6, 2012=>0.589, 2013=>0.61, 2014=>0.621},
#   "Two or more"=>{2011=>0.727, 2012=>0.719, 2013=>0.747, 2014=>0.732},
#   "White"=>{2011=>0.74, 2012=>0.726, 2013=>0.741, 2014=>0.735}},
# :reading=>
#  {"All Students"=>{2011=>0.83, 2012=>0.846, 2013=>0.845, 2014=>0.841},
#   "Asian"=>{2011=>0.898, 2012=>0.893, 2013=>0.902, 2014=>0.855},
#   "Black"=>{2011=>0.662, 2012=>0.695, 2013=>0.67, 2014=>0.704},
#   "Hawaiian/Pacific Islander"=>{2011=>0.745, 2012=>0.833, 2013=>0.867, 2014=>0.932},
#   "Hispanic"=>{2011=>0.749, 2012=>0.772, 2013=>0.773, 2014=>0.008},
#   "Native American"=>{2011=>0.817, 2012=>0.786, 2013=>0.814, 2014=>0.007},
#   "Two or more"=>{2011=>0.842, 2012=>0.846, 2013=>0.856, 2014=>0.009},
#   "White"=>{2011=>0.851, 2012=>0.862, 2013=>0.861, 2014=>0.009}}}
#
