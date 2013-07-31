module Timert
    class Help
      def self.generate
        "usage: timert <command> [ARG]\n\n"\
        "List of commands:\n"\
        "   start [ARG]             Starts the timer. [ARG]: time.\n"\
        "   stop [ARG]              Stops the timer. [ARG]: time.\n"\
        "   report [ARG]            Displays a summary report. [ARG]: number, 'week' or 'month'.\n"\
        "   <anything else>         Adds a task.\n\n"\
        "Usage examples: \n"\
        "   timert start            Starts the timer at the current time.\n"\
        "   timert start 12:20      Starts the timer at the given time.\n"\
        "   timert stop 14          Stops the timer at the given time.\n"\
        "   timert report           Displays a summary for today.\n"\
        "   timert report -1        Displays a summary for yesterday.\n"\
        "   timert report week      Displays a summary for this week.\n"\
        "   timert report month     Displays a summary report for this month.\n"\
        "   timert writing emails   Adds a task: 'writing emails'."
      end
    end
end