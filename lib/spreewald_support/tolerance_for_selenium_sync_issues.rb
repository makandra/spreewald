module ToleranceForSeleniumSyncIssues
  # This is similiar but not entirely the same as Capybara::Node::Base#wait_until or Capybara::Session#wait_until
  def patiently(seconds=Capybara.default_wait_time, &block)
    if page.driver.wait?
      start_time = Time.now
      begin
        block.call
      rescue => e
        raise e if (Time.now - start_time) >= seconds
        sleep(0.05)
        raise Capybara::FrozenInTime, "time appears to be frozen, Capybara does not work with libraries which freeze time, consider using time travelling instead" if Time.now == start_time
        retry
      end
    else
      block.call
    end
  end
end

World(ToleranceForSeleniumSyncIssues)
