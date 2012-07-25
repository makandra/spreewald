if defined?(Timecop)

  When /^the (?:date|time) is "(\d{4}-\d{2}-\d{2}(?: \d{1,2}:\d{2})?)"$/ do |time|
    Timecop.travel Time.parse(time)
  end

  When /^the time is "(\d{1,2}:\d{2})"$/ do |time|
    Timecop.travel Time.parse(time) # date will be today
  end

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
