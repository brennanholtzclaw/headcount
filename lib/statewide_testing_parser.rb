require 'csv'
require 'pry'
require_relative 'file_io'

class StatewideTestParser
  attr_reader :parser_data, :race_files, :grade_files

  def initialize
    @race_files = [:reading, :writing, :math]
    @grade_files = [:third_grade, :eighth_grade]
  end

  def find_district_data_in_mult_files(district,filepath)
    @parser_data = {}

    filepath[:statewide_testing].each do |label, file|
      # binding.pry
      if @grade_files.include?(label)
        a = reads_file_and_returns_1_districts_data_for_one_file(district,label,file)
      elsif @race_files.include?(label)
        a = read_race_files(district,label,file)
      end

      if a == {}
      elsif @parser_data == {}
        @parser_data = a
      else
        @parser_data[label] = a[label]
      end
    end
    @parser_data
  end

  def reads_file_and_returns_1_districts_data_for_one_file(district,label,filepath)
    csv = FileIO.get_data(filepath)
    testing_group = {}

    csv.readlines.each do |data|
      if data["Location"].downcase == district.downcase


        if testing_group[label].nil?
            testing_group = {label => {data["TimeFrame"].to_i => {data["Score"]=>data["Data"].to_f.round(3)}}}
        else
          if testing_group[label][data["TimeFrame"].to_i].nil?
            testing_group[label][data["TimeFrame"].to_i] = {data["Score"]=>data["Data"].to_f.round(3)}
          else
            testing_group[label][data["TimeFrame"].to_i][data["Score"]] = data["Data"].to_f.round(3)
          end
        end
      end
    end
    testing_group
  end

  def read_race_files(district,label,filepath)
    csv = FileIO.get_data(filepath)
    testing_group = {}

    csv.readlines.each do |data|
      if data["Location"].downcase == district.downcase
        if testing_group[label].nil?

            testing_group = {label => {data["Race Ethnicity"]=> {data["TimeFrame"].to_i=>data["Data"].to_f.round(3)}}}
        else
          if testing_group[label][data["Race Ethnicity"]].nil?
            testing_group[label][data["Race Ethnicity"]] = {data["TimeFrame"].to_i=>data["Data"].to_f.round(3)}
          else
            testing_group[label][data["Race Ethnicity"]][data["TimeFrame"].to_i] = data["Data"].to_f.round(3)
          end
        end
      end
    end
    testing_group
  end
end


# Location,Score,TimeFrame,DataFormat,Data
# Location,Race Ethnicity,TimeFrame,DataFormat,Data
# ACADEMY 20,All Students,2011,Percent,0.83
# ACADEMY 20,Asian,2011,Percent,0.8976
# ACADEMY 20,Black,2011,Percent,0.662
# ACADEMY 20,Hawaiian/Pacific Islander,2011,Percent,0.7451
# ACADEMY 20,Hispanic,2011,Percent,0.7486
# ACADEMY 20,Native American,2011,Percent,0.8169
# ACADEMY 20,Two or more,2011,Percent,0.8419
# ACADEMY 20,White,2011,Percent,0.8513
# ACADEMY 20,All Students,2012,Percent,0.84585
# ACADEMY 20,Asian,2012,Percent,0.89328
# ACADEMY 20,Black,2012,Percent,0.69469
# ACADEMY 20,Hawaiian/Pacific Islander,2012,Percent,0.83333
# ACADEMY 20,Hispanic,2012,Percent,0.77167
# ACADEMY 20,Native American,2012,Percent,0.78571
# ACADEMY 20,Two or more,2012,Percent,0.84584
# ACADEMY 20,White,2012,Percent,0.86189
# ACADEMY 20,All Students,2013,Percent,0.84505
# ACADEMY 20,Asian,2013,Percent,0.90193
# ACADEMY 20,Black,2013,Percent,0.66951
# ACADEMY 20,Hawaiian/Pacific Islander,2013,Percent,0.86667
# ACADEMY 20,Hispanic,2013,Percent,0.77278
# ACADEMY 20,Native American,2013,Percent,0.81356
# ACADEMY 20,Two or more,2013,Percent,0.85582
# ACADEMY 20,White,2013,Percent,0.86083
# ACADEMY 20,All Students,2014,Percent,0.84127
# ACADEMY 20,Asian,2014,Percent,0.85531
# ACADEMY 20,Black,2014,Percent,0.70387
# ACADEMY 20,Hawaiian/Pacific Islander,2014,Percent,0.93182
# ACADEMY 20,Hispanic,2014,Percent,0.00778
# ACADEMY 20,Native American,2014,Percent,0.00724
# ACADEMY 20,Two or more,2014,Percent,0.00859
# ACADEMY 20,White,2014,Percent,0.00856


# +{2011=>{"All Students"=>0.68, "Asian"=>0.817, "Black"=>0.425, "Hawaiian/Pacific Islander"=>0.569, "Hispanic"=>0.568, "Native American"=>0.614, "Two or more"=>0.677, "White"=>0.707},
# 2012=>{"All Students"=>0.689, "Asian"=>0.818, "Black"=>0.425, "Hawaiian/Pacific Islander"=>0.571, "Hispanic"=>0.572, "Native American"=>0.571, "Two or more"=>0.69, "White"=>0.714},
# 2013=>{"All Students"=>0.697, "Asian"=>0.805, "Black"=>0.44, "Hawaiian/Pacific Islander"=>0.683, "Hispanic"=>0.588, "Native American"=>0.593, "Two or more"=>0.697, "White"=>0.721},
# 2014=>{"All Students"=>0.699, "Asian"=>0.8, "Black"=>0.421, "Hawaiian/Pacific Islander"=>0.682, "Hispanic"=>0.605, "Native American"=>0.544, "Two or more"=>0.693, "White"=>0.723}}
# 
# +{"All Students"=>{"2011"=>0.68, "2012"=>0.689, "2013"=>0.697, "2014"=>0.699},
# "Asian"=>{"2011"=>0.817, "2012"=>0.818, "2013"=>0.805, "2014"=>0.8},
# "Black"=>{"2011"=>0.425, "2012"=>0.425, "2013"=>0.44, "2014"=>0.421},
# "Hawaiian/Pacific Islander"=>{"2011"=>0.569, "2012"=>0.571, "2013"=>0.683, "2014"=>0.682},
# "Hispanic"=>{"2011"=>0.568, "2012"=>0.572, "2013"=>0.588, "2014"=>0.605},
# "Native American"=>{"2011"=>0.614, "2012"=>0.571, "2013"=>0.593, "2014"=>0.544},
# "Two or more"=>{"2011"=>0.677, "2012"=>0.69, "2013"=>0.697, "2014"=>0.693},
# "White"=>{"2011"=>0.707, "2012"=>0.714, "2013"=>0.721, "2014"=>0.723}}
#
#

