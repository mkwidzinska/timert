class Duration
  attr_reader :hours, :minutes, :seconds

  def initialize(duration)
    @hours = duration / 3600
    @minutes = (duration % 3600) / 60
    @seconds = duration % 60
  end

  def self.from(hours, minutes, seconds)
    Duration.new(hours * 3600 + minutes * 60 + seconds)
  end
end