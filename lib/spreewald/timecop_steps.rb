# coding: UTF-8


# Steps to travel through time using [Timecop](https://github.com/jtrupiano/timecop).
# 
# See [this article](https://makandracards.com/makandra/1222-useful-cucumber-steps-to-travel-through-time-with-timecop) for details.


if defined?(Timecop)

  module TimecopHarness

    # When you have to make your rails app time zone aware you have to go 100%
    # otherwise you are better off ignoring time zones at all.
    # https://makandracards.com/makandra/8723-guide-to-localizing-a-rails-application

    def use_timezones?
      active_record_loaded = defined?(ActiveRecord::Base)
      (!active_record_loaded || ActiveRecord::Base.default_timezone != :local) && Time.zone
    end

    def parse_time(str)
      if use_timezones?
        Time.zone.parse(str)
      else
        Time.parse(str)
      end
    end

    def current_time
      if use_timezones?
        Time.current
      else
        Time.now
      end
    end

  end

  World(TimecopHarness)

  # Example:
  #
  #       Given the date is 2012-02-10
  #       Given the time is 2012-02-10 13:40
  When /^the (?:date|time) is "?(\d{4}-\d{2}-\d{2}(?: \d{1,2}:\d{2})?)"?$/ do |time|
    Timecop.travel(parse_time(time))
  end

  # Example:
  #
  #       Given the time is 13:40
  When /^the time is "?(\d{1,2}:\d{2})"?$/ do |time_without_date|
    Timecop.travel(parse_time(time_without_date)) # date will be today
  end

  # Example:
  #
  #       When it is 10 minutes later
  #       When it is a few hours earlier
  When /^it is (\d+|a|some|a few) (seconds?|minutes?|hours?|days?|weeks?|months?|years?) (later|earlier)$/ do |amount, unit, direction|
    amount = case amount
      when 'a'
        1
      when 'some', 'a few'
        10
      else
        amount.to_i
    end
    amount = -amount if direction == 'earlier'
    Timecop.travel(current_time + amount.send(unit))
  end

  After do
    Timecop.return
  end

end