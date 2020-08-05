module ToleranceForSeleniumSyncIssues
  RETRY_ERRORS = %w[
    Capybara::ElementNotFound
    Spec::Expectations::ExpectationNotMetError
    RSpec::Expectations::ExpectationNotMetError
    Minitest::Assertion
    Capybara::Poltergeist::ClickFailed
    Capybara::ExpectationNotMet
    Selenium::WebDriver::Error::StaleElementReferenceError
    Selenium::WebDriver::Error::NoAlertPresentError
    Selenium::WebDriver::Error::ElementNotVisibleError
    Selenium::WebDriver::Error::NoSuchFrameError
    Selenium::WebDriver::Error::NoAlertPresentError
    Selenium::WebDriver::Error::JavascriptError
    Selenium::WebDriver::Error::UnknownError
    Selenium::WebDriver::Error::NoSuchAlertError
  ]

  class CapybaraWrapper
    def self.default_max_wait_time
      if Capybara.respond_to?(:default_max_wait_time)
        Capybara.default_max_wait_time
      else
        Capybara.default_wait_time
      end
    end

    def self.default_max_wait_time=(value)
      if Capybara.respond_to?(:default_max_wait_time=)
        Capybara.default_max_wait_time = value
      else
        Capybara.default_wait_time = value
      end
    end
  end

  class Patiently
    WAIT_PERIOD = 0.05

    def patiently(seconds, &block)
      started = monotonic_time
      tries = 0
      begin
        tries += 1
        block.call
      rescue Exception => e
        raise e unless retryable_error?(e)
        raise e if (monotonic_time - started > seconds && tries >= 2)
        sleep(WAIT_PERIOD)
        raise Capybara::FrozenInTime, "time appears to be frozen, Capybara does not work with libraries which freeze time, consider using time travelling instead" if monotonic_time == started
        retry
      end
    end

    private

    def monotonic_time
      # We use the system clock (i.e. seconds since boot) to calculate the time,
      # because Time.now may be frozen
      Process.clock_gettime(Process::CLOCK_MONOTONIC)
    end

    def retryable_error?(e)
      RETRY_ERRORS.include?(e.class.name)
    end
  end


  def patiently(seconds = CapybaraWrapper.default_max_wait_time, &block)
    if page.driver.wait?
      Patiently.new.patiently(seconds, &block)
    else
      block.call
    end
  end
end

World(ToleranceForSeleniumSyncIssues)
