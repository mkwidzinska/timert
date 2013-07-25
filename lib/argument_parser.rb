class ArgumentParser
  attr_reader :action, :argument

  def initialize(args)
    if args.length == 0
      @action = @argument = nil
    elsif is_api?(args[0])
      @action = args[0]
      @argument = is_time_method?(@action) ? parse_time(args[1]) : args[1]
    else
      @action = 'add_task'
      @argument = args.join(" ")
    end
  end

  private
  def is_api?(method_name)
    ["start", "stop", "report"].include?(method_name)
  end

  def is_time_method?(method_name)
    ["start", "stop"].include?(method_name)
  end

  def parse_time(arg)
    if arg
      hours, minutes = arg.split(":")
      now = Time.now
      Time.new(now.year, now.month, now.day, hours, minutes).to_i
    end
  end
end
