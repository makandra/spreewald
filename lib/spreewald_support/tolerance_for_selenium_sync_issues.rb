# coding: UTF-8

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

  # This is similiar but not entirely the same as Capybara::Node::Base#wait_until or Capybara::Session#wait_until
  def patiently(seconds = CapybaraWrapper.default_max_wait_time, &block)
    old_wait_time = CapybaraWrapper.default_max_wait_time
    # dont make nested wait_untils use up all the alloted time
    CapybaraWrapper.default_max_wait_time = 0 # for we are a jealous gem
    if page.driver.wait?
      start_time = Time.now
      begin
        block.call
      rescue Exception => e
        raise e unless RETRY_ERRORS.include?(e.class.name)
        raise e if (Time.now - start_time) >= seconds
        sleep(0.05)
        raise Capybara::FrozenInTime, "time appears to be frozen, Capybara does not work with libraries which freeze time, consider using time travelling instead" if Time.now == start_time
        retry
      end
    else
      block.call
    end
  ensure
    CapybaraWrapper.default_max_wait_time = old_wait_time
  end
end

World(ToleranceForSeleniumSyncIssues)
