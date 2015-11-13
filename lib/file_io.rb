require 'csv'
require_relative 'parser'

class FileIO

  def self.get_data(filepath)
    if filepath.class == Hash
      file = filepath.fetch(:enrollment).fetch(:kindergarten)
    else
      file = filepath
    end
    CSV.open(file, headers: true)
  end

end