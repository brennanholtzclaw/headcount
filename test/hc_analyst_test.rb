require_relative 'test_helper'
require_relative '../lib/headcount_analyst'

class HeadcountAnalystTest < Minitest::Test
  attr_reader :dr, :ha, :dr2, :hca

  def create_district_repo_and_hc_analyst
    @dr = DistrictRepository.new
    @dr.load_data( {:enrollment => {
                    :kindergarten => "./test/data/district_test_fixture.csv"}})

    @ha = HeadcountAnalyst.new(dr)
  end

  def create_district_repo_and_hc_analyst_with_multiple_files
    @dr2 = DistrictRepository.new
    @dr2.load_data( {:enrollment => {
                    :kindergarten => "./test/data/district_test_fixture.csv",
                    :high_school_graduation => "./test/data/high_school_grad_sample.csv"}})

    @hca = HeadcountAnalyst.new(@dr2)
  end

  def test_it_accepts_district_repository
    create_district_repo_and_hc_analyst

    assert ha.master_repo
  end

  def test_it_finds_a_districts_enrollment_numbers
    create_district_repo_and_hc_analyst
    expected = {2010=>0.436, 2011=>0.489, 2012=>0.479, 2013=>0.488, 2014=>0.49}

    assert_equal expected, ha.find_all_data("Academy 20",:kindergarten)
  end

  def test_average_finds_average_of_all_years_available_in_data
    create_district_repo_and_hc_analyst

    assert_equal 0.476, ha.average("academy 20", :kindergarten)
    assert_equal 0.69, ha.average("colorado", :kindergarten)
    assert_equal 1.0, ha.average("adams county 14", :kindergarten)
  end

  def test_average_finds_variation_between_two_districts
    create_district_repo_and_hc_analyst

    assert_equal 0.69, ha.kindergarten_participation_rate_variation("academy 20", :against => 'COLORADO')

    assert_equal 2.101, ha.kindergarten_participation_rate_variation('Adams County 14', :against => 'academy 20')
  end

  def test_finds_years_two_districts_have_data
    create_district_repo_and_hc_analyst

    assert_equal [2010, 2011, 2012, 2013, 2014], ha.years_with_data("academy 20", "colorado", :kindergarten)
  end

  def test_finds_rate_in_years_two_districts_have_data
    create_district_repo_and_hc_analyst

    expected = {2010=>2.294, 2011=>2.045, 2012=>2.088, 2013=>2.045, 2014=>2.041}

    assert_equal expected, ha.kindergarten_participation_rate_variation_trend('Adams County 14', :against => 'academy 20')
  end

  def test_it_provides_districts_kg_participation_rate_var_against_state
    create_district_repo_and_hc_analyst_with_multiple_files

    assert_equal 0.69, hca.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'COLORADO')
  end

  def test_it_provides_high_school_graduation_rate_variance_vs_state
    create_district_repo_and_hc_analyst_with_multiple_files

    assert_equal 1.194, hca.high_school_graduation_rate_variation('ACADEMY 20', :against => 'COLORADO')
  end

  def test_it_compares_kg_and_hs_rates
    create_district_repo_and_hc_analyst_with_multiple_files

    assert_equal 0.578, hca.kindergarten_participation_against_high_school_graduation('Academy 20')
    assert_equal 0.578, hca.kindergarten_participation_against_high_school_graduation('ACADEMY 20')
  end

  def test_it_determines_whether_kindergarted_hs_correlation_exists
    create_district_repo_and_hc_analyst_with_multiple_files

    refute   hca.kindergarten_participation_correlates_with_high_school_graduation(for: 'ACADEMY 20')
    assert hca.kindergarten_participation_correlates_with_high_school_graduation(for: 'COLORADO')
    assert hca.kindergarten_participation_correlates_with_high_school_graduation(for: 'COLORADO')
  end

  def test_it_finds_correlation_across_the_state
    create_district_repo_and_hc_analyst_with_multiple_files

    refute hca.kindergarten_participation_correlates_with_high_school_graduation(for: 'STATEWIDE')
  end

  def test_it_finds_correlation_across_the_given_list_of_districts
    create_district_repo_and_hc_analyst_with_multiple_files

    refute hca.kindergarten_participation_correlates_with_high_school_graduation(
    :across => ['Academy 20', 'Adams County 14', 'Cheyenne County Re-5', 'Cheyenne Mountain 12'])
    assert hca.kindergarten_participation_correlates_with_high_school_graduation(
    :across => ['Cheyenne County Re-5', 'Cheyenne Mountain 12'])
  end

  def test_top_statewide_test_year_over_year_growth_raises_insufficient_info_error
    create_district_repo_and_hc_analyst_with_multiple_files

    assert_raises "InsufficientInformationError: A grade must be provided to answer this question" do
      hca.top_statewide_test_year_over_year_growth(subject: :math)
    end

    assert_raises "InsufficientInformationError: A grade must be provided to answer this question" do
      hca.top_statewide_test_year_over_year_growth(grade: 3)
    end
  end

  def test_top_statewide_test_year_over_year_growth_raises_unknown_data_errors
    create_district_repo_and_hc_analyst_with_multiple_files

    assert_raises "UnknownDataError: 9 is not a known grade" do
      hca.top_statewide_test_year_over_year_growth(subject: :math, grade: 9)
    end
  end

  def test_it_finds_one_districts_percentage_growth
    dr_st = DistrictRepository.new
    dr_st.load_data( { :statewide_testing => {
                        :third_grade => "./test/data/3rd_grade_students_stub.csv"}})

    hca_st = HeadcountAnalyst.new(dr_st)

    assert_equal -0.314, hca_st.year_over_year_growth(grade: 3, subject: :math, district: "Academy 20")
  end

  def test_it_finds_top_statewide_leader
    dr_st = DistrictRepository.new
    dr_st.load_data( { :statewide_testing => {
                        :third_grade => "./test/data/3rd_grade_students_stub.csv",
                        :eighth_grade => "./test/data/8th_grade_students_stub.csv",
                        :math => "./test/data/average_race_math.csv",
                        :reading => "./test/data/average_race_reading.csv",
                        :writing => "./test/data/average_race_writing.csv"}})

    hca_st = HeadcountAnalyst.new(dr_st)

    assert_equal ["ADAMS-ARAPAHOE 28J", 0.371], hca_st.top_statewide_test_year_over_year_growth(grade: 3, subject: :math)
  end

  def test_it_finds_top_statewide_leaders
    dr_st = DistrictRepository.new
    dr_st.load_data( { :statewide_testing => {
                        :third_grade => "./test/data/3rd_grade_students_stub.csv",
                        :eighth_grade => "./test/data/8th_grade_students_stub.csv",
                        :math => "./test/data/average_race_math.csv",
                        :reading => "./test/data/average_race_reading.csv",
                        :writing => "./test/data/average_race_writing.csv"}})

    hca_st = HeadcountAnalyst.new(dr_st)

    expected = [["ADAMS-ARAPAHOE 28J", 0.371], ["COLORADO", 0.271], ["AGATE 300", 0.0]]

    assert_equal expected, hca_st.top_statewide_test_year_over_year_growth(grade: 3, top: 3, subject: :math)
  end

#
# ha.top_statewide_test_year_over_year_growth(grade: 3)

end
