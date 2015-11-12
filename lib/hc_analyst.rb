require 'csv'
require 'pry'
require './lib/district_repository'

class HeadCountAnalyst
attr_reader :master_repo

  def initialize(data)
    @master_repo = data
  end

  def find_all_data(district, dataset)
    @master_repo.er.enrollments[district.downcase].data[dataset]
  end

  def average(district, dataset)
    district_dataset = find_all_data(district, dataset)
    (district_dataset.values.inject(:+) / district_dataset.values.length).round(3)
  end

  def kindergarten_participation_rate_variation(district, options)
    d2 = options[:against]
    (average(district,:kindergarten_participation)/average(d2,:kindergarten_participation)).round(3)
  end

  def years_with_data(dist1, dist2)
      a = find_all_data(dist1, :kindergarten_participation)
      b = find_all_data(dist2, :kindergarten_participation)
      a.keys & b.keys
  end

  def kindergarten_participation_rate_variation_trend(dist1, options)
    dist2 = options[:against]
    a = years_with_data(dist1, dist2)
    hash = {}
    a.each do |year|
      b = find_all_data(dist1, :kindergarten_participation)[year]
      c = find_all_data(dist2, :kindergarten_participation)[year]
      hash[year] = (b/c).round(3)
    end
    hash
  end
end