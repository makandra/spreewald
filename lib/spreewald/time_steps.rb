# coding: UTF-8


# Steps to travel through time
#
# This uses [Timecop](https://github.com/jtrupiano/timecop) or Active Support 4.1+ to stub Time.now / Time.current.
# The user is responsible for including one of the two gems.
#
# Please note that the two approaches branch. While ActiveSupport will freeze the time, Timecop will keep it running.
# FILE_COMMENT_END

major_minor_rails_version = defined?(ActiveSupport) ? [ActiveSupport::VERSION::MAJOR, ActiveSupport::VERSION::MINOR] : [0, 0]
is_at_least_rails_4_1 = (major_minor_rails_version <=> [4, 1]) != -1

if defined?(Timecop) || is_at_least_rails_4_1

  module TimeHelpers

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

    if defined?(Timecop)
      # Emulate ActiveSupport time helper methods with Timecop - don't rename these methods
      def travel(duration)
        Timecop.travel(current_time + duration)
      end

      def travel_to(date_or_time)
        Timecop.travel(date_or_time)
      end

      def travel_back
        Timecop.return
      end
    else
      require 'active_support/testing/time_helpers'
      include ActiveSupport::Testing::TimeHelpers
    end

  end

  World(TimeHelpers)

  # Example:
  #
  #     Given the date is 2012-02-10
  #     Given the time is 2012-02-10 13:40
  When /^the (?:date|time) is "?(\d{4}-\d{2}-\d{2}(?: \d{1,2}:\d{2})?)"?$/ do |time|
    travel_to parse_time(time)
  end.overridable

  # Example:
  #
  #     Given the time is 13:40
  When /^the time is "?(\d{1,2}:\d{2})"?$/ do |time_without_date|
    travel_to parse_time(time_without_date) # date will be today
  end.overridable

  # Example:
  #
  #     When it is 10 minutes later
  #     When it is a few hours earlier
  When /^it is (\d+|an?|some|a few) (seconds?|minutes?|hours?|days?|weeks?|months?|years?) (later|earlier)$/ do |amount, unit, direction|
    amount = case amount
    when 'a', 'an'
      1
    when 'some', 'a few'
      10
    else
      amount.to_i
    end
    amount = -amount if direction == 'earlier'
    travel amount.send(unit)
  end.overridable

  After do
    travel_back
  end

end
