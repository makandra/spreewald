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
      started = Time.now
      tries = 0
      begin
        tries += 1
        disable_capybara_waiting do
          # we do not want Capybara's own methods to wait themselves
          block.call
        end
      rescue Exception => e
        raise e unless retryable_error?(e)
        raise e if (Time.now - started > CapybaraWrapper.default_max_wait_time && tries >= 2)
        sleep(WAIT_PERIOD)
        raise Capybara::FrozenInTime, "time appears to be frozen, Capybara does not work with libraries which freeze time, consider using time travelling instead" if Time.now == started
        retry
      end
    end

    private

    def retryable_error?(e)
      RETRY_ERRORS.include?(e.class.name)
    end

    def disable_capybara_waiting
      old_wait_time = CapybaraWrapper.default_max_wait_time
      CapybaraWrapper.default_max_wait_time = 0
      yield
    ensure
      CapybaraWrapper.default_max_wait_time = old_wait_time
    end
  end


  def patiently(seconds = nil, &block)
    if page.driver.wait?
      Patiently.new.patiently(seconds, &block)
    else
      block.call
    end
  end
end

World(ToleranceForSeleniumSyncIssues)
