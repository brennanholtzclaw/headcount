require 'csv'
require 'pry'
require 'bigdecimal'
require 'bigdecimal/util'
require_relative 'district_repository'

class HeadcountAnalyst
attr_reader :master_repo
attr_accessor :winner, :single_test_ind, :all_subjects_test_ind

  def initialize(data)
    @master_repo = data
  end

  def find_all_data(district, file_label)
    @master_repo.er.enrollments[district.upcase].data[file_label]
  end

  def average(district, file_label)
    dataset = find_all_data(district, file_label)
    (dataset.values.inject(:+) / dataset.values.length).round(3)
  end

  def kindergarten_participation_rate_variation(district, options)
    d2 = options[:against]
    (average(district, :kindergarten)/average(d2, :kindergarten)).round(3)
  end

  def years_with_data(dist1, dist2, data_label)
      a = find_all_data(dist1, data_label)
      b = find_all_data(dist2, data_label)
      a.keys & b.keys
  end

  def grades
    {3 => :third_grade, 8 => :eighth_grade}
  end

  def subjects
    {:math => "Math", :reading => "Reading", :writing => "Writing"}
  end

  def kindergarten_participation_rate_variation_trend(dist1, options)
    dist2 = options[:against]
    a = years_with_data(dist1, dist2, :kindergarten)
    hash = {}
    a.each do |year|
      b = find_all_data(dist1, :kindergarten)[year]
      c = find_all_data(dist2, :kindergarten)[year]
      hash[year] = (b/c).round(3)
    end
    hash
  end

  def high_school_graduation_rate_variation(district, options)
    d2 = options[:against]
    (average(district, :high_school_graduation)/average(d2, :high_school_graduation)).round(3)
  end

  def kindergarten_participation_against_high_school_graduation(d)
    k_var = kindergarten_participation_rate_variation(d, :against => "COLORADO")
    grad_var = high_school_graduation_rate_variation(d, :against => "COLORADO")

    (k_var / grad_var).round(3)
  end

  def kindergarten_participation_correlates_with_high_school_graduation(options)
    return kg_v_hs_correlation_statewide? if options[:for] == 'STATEWIDE'
    return kg_v_hs_correlation_across_districts?(options[:across]) if options[:across]
    return correlation?(options) if options[:for] && options[:for] != 'STATEWIDE'
  end

  def correlation?(options)
    if options[:for] && options[:for] != 'STATEWIDE'
      kg_v_hs = kindergarten_participation_against_high_school_graduation(options[:for])
      true if kg_v_hs > 0.6 && kg_v_hs < 1.5
    end
  end

  def find_names_common_to_kg_and_hs_grad_files
    kg_file = @master_repo.er.filepath[:enrollment][:kindergarten]
    hs_grad_file = @master_repo.er.filepath[:enrollment][:high_school_graduation]
    kg_and_hs_files = [kg_file, hs_grad_file]
    MasterParser.all_common_names(kg_and_hs_files)
  end

  def kg_v_hs_correlation_statewide?
    districts = find_names_common_to_kg_and_hs_grad_files
    results = districts.map do |district|
      kindergarten_participation_correlates_with_high_school_graduation(:for => district)
    end
    if (results.count(true)/results.length) >= 0.7 then true else false end
  end

  def kg_v_hs_correlation_across_districts?(districts)
    results = districts.map do |district|
      kindergarten_participation_correlates_with_high_school_graduation(:for => district)
    end
    if (results.count(true)/results.length) >= 0.7 then true else false end
  end

  def year_over_year_growth(options)
    # binding.pry
    districts_data =  @master_repo.district_repo[options[:district].upcase].testing_data.data[grades[options[:grade]]]
    first_year_data = first_year_data_pair(districts_data,options)
    last_year_data = last_year_data_pair(districts_data,options)
    years_evaluated = ((last_year_data[0]) - (first_year_data[0]))
    return -1000.0 if first_year_data[0] != 2008 && last_year_data != 2014 && single_test_ind == false
    return -1000.0 if first_year_data[0] == 0 || last_year_data[0] ==0
    return -1000.0 if first_year_data[0] != 2008 && last_year_data != 2014 && all_subjects_test_ind == true
    ((last_year_data[1].to_d - first_year_data[1].to_d)/years_evaluated).to_f.round(3)
  end

  def first_year_data_pair(districts_data,options)
    first_year_data = [0, 0.0]
    years_asc = districts_data.keys.sort

    years_asc.each do |year|
      score_in_csv =  districts_data[year][options[:subject]]
      if score_in_csv == 0 || score_in_csv == '#VALUE' || score_in_csv == 'N/A' || score_in_csv == 'LNE'
      elsif districts_data[year][options[:subject]] > 0
        first_year_data  = [year, districts_data[year][options[:subject]]]
        break
      end
    end
    first_year_data
  end

  def last_year_data_pair(districts_data,options)
    last_year_data = [0, 0.0]
    years_desc = districts_data.keys.sort.reverse

    years_desc.each do |year|
      score_in_csv =  districts_data[year][options[:subject]]
      if score_in_csv == 0 || score_in_csv == '#VALUE' || score_in_csv == 'N/A' || score_in_csv == 'LNE'
      elsif districts_data[year][options[:subject]] > 0
        last_year_data  = [year, districts_data[year][options[:subject]]]
        break
      end
    end
    last_year_data
  end

  def year_over_year_growth_all_subjects(options)
    list = subjects.map do |subject|
      temp_options = options
      temp_options[:subject] = subject[0]
      year_over_year_growth(temp_options)
    end
    # binding.pry
    options.delete(:subject) if options[:subject]
    return -1000.0 if list.include?(-1000.0)
    (list.reduce(:+)/subjects.length).to_f.round(3)
  end

  def year_over_year_growth_all_subjects_weighted(options)
    weighting_total = options[:weighting][:math] + options[:weighting][:reading] + options[:weighting][:writing]
    fail WeightingInputError, "weights MUST add up to 1" if weighting_total != 1

    list = subjects.map do |subject|
      temp_options = options
      temp_options[:subject] = subject[0]
      year_over_year_growth(temp_options)*options[:weighting][subject[0]]
    end
    options.delete(:subject) if options[:subject]
    list.reduce(:+).to_f.round(3)
  end

  def top_statewide_test_year_over_year_growth(options)
    fail InsufficientInformationError, "A grade must be provided to answer this question" if options[:grade].nil?
    fail UnknownDataError, "#{options[:grade]} is not a known grade" if ![3,8].include?(options[:grade])

    @single_test_ind = true if options[:subject] && options[:weighting].nil?
    @all_subjects_test_ind = true if options[:subject].nil? && options[:weighting].nil?

    winner = @master_repo.district_repo.map do |district|
      # binding.pry
      unless @master_repo.district_repo[district[0]].testing_data.data[grades[options[:grade]]].nil?
        options[:district] = district[0]
        result = lookup_method_for_capturing_scores(options)
        result if !result[1].nan? && !(result[0] == "COLORADO")
      end
    end.compact
    # binding.pry

    @single_test_ind = false
    @all_subjects_test_ind = false

    winner_qty = options[:top] || 1
    winner = winner.sort_by{|elem| elem[1]}.reverse[0..(winner_qty - 1)]
    winner.flatten! if winner_qty == 1
    winner
  end

  def lookup_method_for_capturing_scores(options)
    if options[:subject].nil? && options[:weighting].nil?
# binding.pry
      [options[:district], year_over_year_growth_all_subjects(options)]
    elsif options[:subject].nil? && !options[:weighting].nil?
# binding.pry
      [options[:district], year_over_year_growth_all_subjects_weighted(options)]
    else
# binding.pry
      [options[:district], year_over_year_growth(options)]
    end
  end
end

class WeightingInputError < ArgumentError
end

class InsufficientInformationError < ArgumentError
end

class UnknownDataError < ArgumentError
end