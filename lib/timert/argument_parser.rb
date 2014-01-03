require_relative "date_util"

module Timert
  class ArgumentParser
    attr_reader :action, :argument

    def initialize(args)
      if args.empty?
        @action = "help"
        @argument = nil
      elsif is_api?(args[0])
        @action = args[0]
        @argument = api_argument(@action, *args[1..-1])
      else
        @action = 'add_task'
        @argument = args.join(" ")
      end
    end

    private
    def is_api?(method_name)
      ["start", "stop", "report"].include?(method_name)
    end

    def api_argument(action, *args)
      if is_time_method?(action)
        parse_time(args[0])
      elsif is_report?(action)
        parse_report_arg(args)
      end
    end

    def is_time_method?(method_name)
      ["start", "stop"].include?(method_name)
    end

    def is_report?(method_name)
      method_name == "report"
    end

    def is_month_or_week?(args)
      args.include?("month") || args.include?("week")
    end

    def parse_report_arg(args)
      is_month_or_week?(args) ? args.join(" ") : args[0]
    end

    def parse_time(arg)
      DateUtil.parse_time(arg)
    end
  end
end