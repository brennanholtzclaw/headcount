require 'csv'
require 'pry'
require_relative 'file_io'

class EconomicProfileParser
  attr_accessor :data_group

  def parser_key(file_symbol)
  end

  def arrange_district_data(district,filepath)
    @parser_data = {}
    filepath[:economic_profile].each do |label, file|
      data = med_hh_income_parser(district,label,file) if label == :median_household_income
      data = kids_in_poverty_parser(district,label,file) if label == :children_in_poverty
      data = free_lunch_parser(district,label,file) if label == :free_or_reduced_price_lunch
      data = title_i_parser(district,label,file) if label == :title_i

      if data.empty? || data.nil?
      else
        @parser_data[data.keys[0]] = data.values[0]
      end
    end
    @parser_data
  end

  def med_hh_income_parser(district,label,filepath)
    csv = FileIO.get_data(filepath)
    ep_group = {label => {}}

    csv.readlines.each do |data|
      if data["Location"].downcase == district.downcase
          ep_group[label][data["TimeFrame"].split("-").map(&:to_i)] = data["Data"].to_i
      end
    end
    ep_group
  end

  def kids_in_poverty_parser(district,label,filepath)
    csv = FileIO.get_data(filepath)
    kp_group = {label => {}}

    csv.readlines.each do |data|
      if data["Location"].downcase == district.downcase && data["DataFormat"] == "Percent"
          kp_group[label][data["TimeFrame"].to_i] = data["Data"].to_f.round(3)
      end
    end
    kp_group
  end

  def format_data(row)
    data_value = row["Data"].to_f.round(3)  if row["DataFormat"] == "Percent"
    data_value = row["Data"].to_i           if row["DataFormat"] == "Number"
    data_value
  end

  def free_lunch_parser(district,label,filepath)
    csv = FileIO.get_data(filepath)
    fl_group = {label => {}}

    translate_format = {"Percent" => :percentage, "Number" => :total}

    selected_rows = csv.readlines.select do |data|
      data["Location"].downcase == district.downcase && data["Poverty Level"] == "Eligible for Free or Reduced Lunch"
    end

    selected_rows.each do |data|
      formatted = translate_format[data["DataFormat"]]
      value = format_data(data)
      time = data["TimeFrame"].to_i
      fl_group[label][time] = {formatted => value} if fl_group[label].empty?
      fl_group[label][time][formatted] = value if fl_group[label][time]
      fl_group[label][time] = {formatted => value} if fl_group[label][time].nil?
    end
    fl_group
  end

  def title_i_parser(district,label,filepath)
    csv = FileIO.get_data(filepath)
    ti_group = {label => {}}

    csv.readlines.each do |data|
      if data["Location"].downcase == district.downcase && data["DataFormat"] == "Percent"
          ti_group[label][data["TimeFrame"].to_i] = data["Data"].to_f.round(3)
      end
    end
    ti_group
  end

end
