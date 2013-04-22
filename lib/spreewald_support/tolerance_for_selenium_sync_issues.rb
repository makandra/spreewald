# coding: UTF-8

module ToleranceForSeleniumSyncIssues
  RETRY_ERRORS = %w[Capybara::ElementNotFound Spec::Expectations::ExpectationNotMetError RSpec::Expectations::ExpectationNotMetError Capybara::Poltergeist::ClickFailed Selenium::WebDriver::Error::StaleElementReferenceError]

  # This is similiar but not entirely the same as Capybara::Node::Base#wait_until or Capybara::Session#wait_until
  def patiently(seconds=Capybara.default_wait_time, &block)
    exceptions_caught = []
    old_wait_time = Capybara.default_wait_time
    # dont make nested wait_untils use up all the alloted time
    Capybara.default_wait_time = 0 # for we are a jealous gem
    if page.driver.wait?
      start_time = Time.now
      begin
        block.call
      rescue Exception => e
        exceptions_caught << e
        unexpected_exception = ! RETRY_ERRORS.include?(e.class.name)
        timeout_reached = (Time.now - start_time) >= seconds
        if unexpected_exception or timeout_reached

          # It seems that console output is eaten up by cucumber
          puts "Exceptions caught so far: #{exceptions_caught.collect(&:class).collect(&:name).uniq.join(", ")}"
          # another idea is to overwrite 'Exception#to_s', but we aren't sure if this is a good idea

          raise e
        end
        sleep(0.05)
        if Time.now == start_time
          raise Capybara::FrozenInTime, "time appears to be frozen, Capybara does not work with libraries which freeze time, consider using time travelling instead"
        end
        retry
      end
    else
      block.call
    end
  ensure
    Capybara.default_wait_time = old_wait_time
  end
end

World(ToleranceForSeleniumSyncIssues)


# put this step into another real project to test patiently_do

#When /^I provoke patiently do to catch several exceptions$/ do
#  retry_errors = [Capybara::ElementNotFound.new, Spec::Expectations::ExpectationNotMetError.new]
#  # further RETRY_ERRORS RSpec::Expectations::ExpectationNotMetError Capybara::Poltergeist::ClickFailed Selenium::WebDriver::Error::StaleElementReferenceError
#  count = -1
#  patiently do
#    "".should_not be_present
#    count += 1
#    raise retry_errors[count % 2]
#  end
#end
