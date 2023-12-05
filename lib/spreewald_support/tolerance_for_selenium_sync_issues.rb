require 'spreewald_support/capybara_wrapper'

module ToleranceForSeleniumSyncIssues
  RETRY_ERRORS = %w[
    ActionController::UrlGenerationError
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

  class Patiently
    WAIT_PERIOD = 0.05

    def patiently(seconds, &block)
      patiently_started = monotonic_time
      tries = 0
      begin
        tries += 1
        block_started = monotonic_time
        block.call
      rescue Exception => e
        raise e unless retryable_error?(e)
        raise e if (block_started - patiently_started > seconds && tries >= 2)
        sleep(WAIT_PERIOD)
        raise Capybara::FrozenInTime, "time appears to be frozen, Capybara does not work with libraries which freeze time, consider using time travelling instead" if monotonic_time == patiently_started
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


  def patiently(seconds = Spreewald::CapybaraWrapper.default_max_wait_time, &block)
    if page.driver.wait?
      Patiently.new.patiently(seconds, &block)
    else
      block.call
    end
  end
end

World(ToleranceForSeleniumSyncIssues)
