
class MasterParser

  def self.district(data)
    data["Location"]
  end

end


# FileIO.get_data(filepath).each do |data|
#   @district_repo[MasterParser.district] = District.new(MasterParser.district)
#
#   @district_repo[data["Location"]] = District.new(data["Location"])
