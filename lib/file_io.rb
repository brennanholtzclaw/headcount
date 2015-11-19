require 'csv'
require_relative 'parser'

class FileIO
  def self.get_data(filepath)
    CSV.open(filepath, headers: true)
  end
end