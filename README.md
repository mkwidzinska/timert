# Timert

Timert is a simple time tracking tool for the console.
The main feature is that you can specify an hour you want the timer
to start or to stop. Moreover, it provides summary reports for a given day, 
week or month.

# Installation

Timert is a RubyGem and can be installed using:

``` shell
$ gem install timert
```

and run it:

``` shell
$ timert
```

# Commands

List of commands:

``` shell
start [ARG]             Starts the timer. [ARG]: hour.\n"\
stop [ARG]              Stops the timer. [ARG]: hour.\n"\
report [ARG]            Displays a summary report. [ARG]: number, 'week' or 'month'.\n"\
<anything else>         Adds a task.\n\n"\
```

# Examples

Start the timer at the current hour:

``` shell
$ timert start
```

Start the timer at the given hour:

``` shell
$ timert start 12:20      

Stop the timer at the given hour:

``` shell
$ timert stop 14
```

Display a summary for today:

``` shell
$ timert report
```

Display a summary for yesterday:

``` shell
$ timert report -1
```

Display a summary for this week:

``` shell
$ timert report week
```

Display a summary report for this month:

``` shell
$ timert report month
```

Add a task: 'writing emails':

``` shell
$ timert writing emails
```

A sample report:

``` shell
REPORT FOR TODAY

Tasks:
writing emails

Work time:
12:20:00 - 14:00:00

Total elapsed time:
1h 40min 0sec

Summary:
2.0 - writing emails
```