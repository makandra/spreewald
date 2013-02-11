# coding: UTF-8


# Steps to travel through time using [Timecop](https://github.com/jtrupiano/timecop).
# 
# See [this article](https://makandracards.com/makandra/1222-useful-cucumber-steps-to-travel-through-time-with-timecop) for details.


if defined?(Timecop)

  # Example:
  #
  #       Given the date is 2012-02-10
  #       Given the time is 2012-02-10 13:40
  When /^the (?:date|time) is "?(\d{4}-\d{2}-\d{2}(?: \d{1,2}:\d{2})?)"?$/ do |time|
    Timecop.travel Time.parse(time)
  end

  # Example:
  #
  #       Given the time is 13:40
  When /^the time is "?(\d{1,2}:\d{2})"?$/ do |time|
    Timecop.travel Time.parse(time) # date will be today
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
    Timecop.travel(Time.now + amount.send(unit))
  end

  After do
    Timecop.return
  end

end
