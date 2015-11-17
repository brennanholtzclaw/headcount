require 'csv'
require 'pry'
require './lib/district_repository'

class HeadcountAnalyst
attr_reader :master_repo

  def initialize(data)
    @master_repo = data
  end

  def find_all_data(district, file_label)
    @master_repo.er.enrollments[district.downcase].data[district.downcase][file_label]
  end

  def average(district, file_label)
    district_dataset = find_all_data(district, file_label)
    (district_dataset.values.inject(:+) / district_dataset.values.length).round(3)
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

  def kindergarten_participation_against_high_school_graduation(district)
    kindergarten_variation = kindergarten_participation_rate_variation(district, :against => "COLORADO")

    graduation_variation = high_school_graduation_rate_variation(district, :against => "COLORADO")

    (kindergarten_variation / graduation_variation).round(3)
  end

  def kindergarten_participation_correlates_with_high_school_graduation(options)
    if options[:for] == 'STATEWIDE'
      kg_v_hs_correlation_statewide
    elsif options[:across]
      kg_v_hs_correlation_across_districts(options[:across])
    else
      district = options[:for]

      kg_v_hs = kindergarten_participation_against_high_school_graduation(district)

      if kg_v_hs > 0.6 && kg_v_hs < 1.5
        true
      else
        false
      end
    end
  end

  def find_names_common_to_kg_and_hs_grad_files
    kg_file = @master_repo.er.filepath[:enrollment][:kindergarten]
    hs_grad_file = @master_repo.er.filepath[:enrollment][:high_school_graduation]

    kg_and_hs_files = [kg_file, hs_grad_file]

    MasterParser.all_common_names(kg_and_hs_files)
  end

  def kg_v_hs_correlation_statewide
    districts = find_names_common_to_kg_and_hs_grad_files

    results = districts.map do |district|
      kindergarten_participation_correlates_with_high_school_graduation(:for => district)
    end

    count_true = results.count(true).to_f
    count_total = results.length.to_f

    percentage_true = (count_true/count_total)

    if percentage_true >= 0.7
      true
    else
      false
    end
  end

  def kg_v_hs_correlation_across_districts(districts)
    results = districts.map do |district|
      kindergarten_participation_correlates_with_high_school_graduation(:for => district)
    end

    count_true = results.count(true).to_f
    count_total = results.length.to_f

    percentage_true = (count_true/count_total)

    if percentage_true >= 0.7
      true
    else
      false
    end
  end
end