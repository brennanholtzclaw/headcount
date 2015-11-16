require 'csv'
require 'pry'
require './lib/district_repository'

class HeadcountAnalyst
attr_reader :master_repo

  def initialize(data)
    @master_repo = data
  end

  def find_all_data(district)
    @master_repo.er.enrollments[district.downcase].data[district.downcase][:kindergarten]
  end

  def average(district)
    district_dataset = find_all_data(district)
    (district_dataset.values.inject(:+) / district_dataset.values.length).round(3)
  end

  def kindergarten_participation_rate_variation(district, options)
    d2 = options[:against]
    (average(district)/average(d2)).round(3)
  end

  def years_with_data(dist1, dist2)
      a = find_all_data(dist1)
      b = find_all_data(dist2)
      a.keys & b.keys
  end

  def kindergarten_participation_rate_variation_trend(dist1, options)
    dist2 = options[:against]
    a = years_with_data(dist1, dist2)
    hash = {}
    a.each do |year|
      b = find_all_data(dist1)[year]
      c = find_all_data(dist2)[year]
      hash[year] = (b/c).round(3)
    end
    hash
  end

  def kindergarten_participation_against_high_school_graduation(district)

  end

end