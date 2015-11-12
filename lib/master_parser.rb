require 'pry'
class MasterParser

  # def self.district(data)
  #   data["Location"]
  # end

  def self.names(data)
    names = []
    data.each do |line|
      names << line["Location"]
    end
    names.uniq
  end

  def self.years(data)
    years = []
    data.each do |line|
      years << line["TimeFrame"]
    end
    years.uniq
  end

  def self.values(data)
    values = []
    data.each do |line|
      values << line["Data"].to_f.round(3)
    end
    values
  end

  def self.flattened_data(data, district)
    districts_data = {}
    data.each do |line|
      if districts_data[line["Location"].downcase].nil?
        districts_data[line["Location"].downcase] = {line["TimeFrame"].to_i=>line["Data"].to_f.round(3)}
      else
        districts_data[line["Location"].downcase][line["TimeFrame"].to_i] = line["Data"].to_f.round(3)
      end
    end
    districts_data[district.downcase]
  end


  # FileIO.get_data(@filepath).each do |line|
  #   district = line["Location"].downcase
  #   if @enrollments[line["Location"].downcase].nil?
  #     @enrollments[district] = Enrollment.new(@parser.pretty_data(district))
  #   end
  # end

end


# FileIO.get_data(filepath).each do |data|
#   @district_repo[MasterParser.district] = District.new(MasterParser.district)
#
#   @district_repo[data["Location"]] = District.new(data["Location"])
