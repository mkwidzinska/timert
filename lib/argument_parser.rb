class ArgumentParser
  attr_reader :action, :argument

  def initialize(args)
		if args.length == 0
  		@action = @argument = nil
  	elsif is_api?(args[0])
    	@action = args[0]
    	@argument = args[1]
		else
    	@action = 'add_task'
    	@argument = args.join(" ")
		end
  end

  private
  def is_api?(method_name)
    ["start", "stop", "report"].include?(method_name)
  end
end
