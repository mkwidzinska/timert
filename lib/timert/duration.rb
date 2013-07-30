module Timert
  class Duration
    attr_reader :hours, :minutes, :seconds, :value

    def initialize(duration)    
      @hours = duration / 3600
      @minutes = (duration % 3600) / 60
      @seconds = duration % 60
      @value = duration
    end

    def self.from(hours, minutes, seconds)
      Duration.new(hours * 3600 + minutes * 60 + seconds)
    end

    def round
      ((value / 1800.0).ceil / 2.0).to_s
    end

    def to_s
      "#{hours}h #{minutes}min #{seconds}sec"
    end
  end
end