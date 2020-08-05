# The time steps use the timecop gem or ActiveSupport 4.1, depending on what is
# available.
# In order to test both implementations, the rails 3 test projects (Capybara 1 & 2)
# use timecop to run this feature, while the rails 4 & 6 test projects (Capybara 6)
# use ActiveSupport for this feature.

Feature: Time steps
  Scenario: /^the (?:date|time) is "?(\d{4}-\d{2}-\d{2}(?: \d{1,2}:\d{2})?)"?$/
    Given the time is "2020-02-03 02:12"
    When I go to "/static_pages/time"
    Then I should see "The current date is 2020-02-03."
      And I should see "The current time is 02:12."

    Given the time is 23:24
    When I go to "/static_pages/time"
    Then I should see "The current time is 23:24."

  Scenario: Set just the date
    Given the date is "2020-02-03"
    When I go to "/static_pages/time"
    Then I should see "The current date is 2020-02-03."

  Scenario: it is (\d+|an?|some|a few) (seconds?|minutes?|hours?|days?|weeks?|months?|years?) (later|earlier)
    Given the time is "23:00"
    When it is 24 minutes later
      And I go to "/static_pages/time"
    Then I should see "The current time is 23:24."

    When it is an hour earlier
      And I go to "/static_pages/time"
    Then I should see "The current time is 22:24"
