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
      # a = dist_1_data # need to define
      # b = dist_2_data # need to define
      # compare = a/b
      hash[year] = (b/c).round(3)
      # binding.pry
    end
    hash
      # hash[year] = kindergarten_participation_rate_variation(dist1,options)
  end

    # {2009 => 0.766, 2010 => 0.566, 2011 => 0.46 }

end


# which years do they both have data?

# create hash where key is year and value is kprvs for that year

#
# x = [1, 2, 4]
# y = [5, 2, 4]
# z = x & y # => [2, 4]
#
# trend = {}
# z.each do |year|
#   trend[year] = kindergarten_participation_rate_variation(district,)
# end
