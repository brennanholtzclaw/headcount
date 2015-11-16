require 'csv'
require_relative 'parser'

class FileIO

  def self.get_data(filepath)
    if filepath[:enrollment]
      file = filepath.fetch(:enrollment).fetch(:kindergarten)
    else
      file = filepath.fetch(:kindergarten)
      end
    CSV.open(file, headers: true)
  end
end