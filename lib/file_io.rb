require 'csv'
require_relative 'parser'

class FileIO

  def self.get_data(filepath)
    file = filepath.fetch(:enrollment).fetch(:kindergarten)
    CSV.open(file, headers: true)
  end

end