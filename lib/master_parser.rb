require 'pry'

class MasterParser

  def self.names(data)
    names = []
    data.each do |line|
      names << line["Location"].upcase
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

  def self.files(nested_filepaths, category=:all)
    return [] if nested_filepaths.nil?

    file_list = []
    if category == :all
      nested_filepaths.keys.each do |key|
        file_list += nested_filepaths[key].values
      end
    else
      file_list = nested_filepaths[category].values
    end
    file_list
  end

  def self.all_uniq_names(nested_filepaths=nil,category=:all)
    names_array = []
    files(nested_filepaths, category).each do |file|
      names_array += names(FileIO.get_data(file))
    end
    names_array.uniq
  end

  def self.all_common_names(files_array,category=:all)
    names_array = []

    files_array.each do |file|
      if names_array == []
        names_array = names(FileIO.get_data(file))
      else
        names_array = names_array & names(FileIO.get_data(file))
      end
    end
    names_array
  end

  def self.flattened_data(dataset, district)
    districts_data = {}

    dataset.each do |line|
      if line["Location"].downcase == district.downcase
        if districts_data == {}
          districts_data[:name] = line["Location"]
          districts_data[:data] = {line["TimeFrame"].to_i => line["Data"].to_f.round(3)}
        elsif districts_data != {}
          districts_data[:data][line["TimeFrame"].to_i] = line["Data"].to_f.round(3)
        end
      end
    end
    districts_data[:data]
  end

  def self.pretty_data(data, district)
    pretty = {}

    pretty = {name: district.upcase, kindergarten_participation: flattened_data(data, district)}
  end

end