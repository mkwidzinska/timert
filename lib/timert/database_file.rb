require 'json'

module Timert
  class DatabaseFile

    def initialize(path)
      @path = path
    end

    def load
      File.open(@path, 'a+') do |file|
        file.size > 0 ? JSON.load(file) : {}
      end
    end

    def save(hash)
      File.open(@path, 'w+') { |f| f.write(hash.to_json) }
    end
  end
end