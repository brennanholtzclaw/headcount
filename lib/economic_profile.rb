require 'pry'

class EconomicProfile
  attr_reader :data, :cip, :mhi, :frpl, :title_i

  def initialize(data)
    @data = data
    @mhi = @data[:median_household_income] if @data[:median_household_income]
    @cip = @data[:children_in_poverty] if @data[:children_in_poverty]
    @frpl = @data[:free_or_reduced_price_lunch] if @data[:free_or_reduced_price_lunch]
    @title_i = @data[:title_i] if @data[:title_i]
  end

  def relevant_yr_ranges(year)
    mhi.select do |year_range, income|
      (year_range[0]..year_range[1]).include?(year)
    end
  end

  def estimated_median_household_income_in_year(year)
    income_list = relevant_yr_ranges(year).map { |year_range, income| income }
    data_error if income_list == []
    (income_list.reduce(:+))/(income_list.size)
  end

  def median_household_income_average
    mhi.values.reduce(:+)/mhi.values.count
  end

  def children_in_poverty_in_year(year)
    data_error if cip[year].nil?
    cip[year]
  end

  def children_in_poverty_in_year(year)
    data_error if cip[year].nil?
    cip[year]
  end

  def free_or_reduced_price_lunch_percentage_in_year(year)
    data_error if frpl[year].nil?
    frpl[year][:percentage]
  end

  def free_or_reduced_price_lunch_number_in_year(year)
    data_error if frpl[year].nil?
    frpl[year][:total]
  end

  def title_i_in_year(year)
    data_error if title_i[year].nil?
    title_i[year]
  end

  def data_error
    fail UnknownDataError
  end

end

class UnknownDataError < ArgumentError

end
