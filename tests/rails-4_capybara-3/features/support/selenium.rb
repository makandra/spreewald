def shared_options
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--mute-audio')
  options.add_argument('--disable-infobars')
  options.add_preference('credentials_enable_service', false)
  options.add_preference('profile.password_manager_enabled', false)
  if ENV['CI']
    options.add_argument('--no-sandbox')
    options.add_argument('--headless')
    options.add_argument('--disable-gpu')
    options.add_argument('--disable-dev-shm-usage')
  end
  options
end


Capybara.register_driver :selenium do |app|
  options = shared_options
  options.add_emulation(device_metrics: { width: 1024, height: 1024, touch: true })
  args = {
      browser: :chrome,
      options: options,
  }
  args[:url] = ENV['CHROMEDRIVER_URL'] if ENV['CHROMEDRIVER_URL']
  Capybara::Selenium::Driver.new(app, args)
end

Capybara.register_driver :mobile_selenium do |app|
  options = shared_options
  options.add_emulation(device_name: 'iPhone 6')
  args = {
      browser: :chrome,
      options: options,
  }
  args[:url] = ENV['CHROMEDRIVER_URL'] if ENV['CHROMEDRIVER_URL']
  Capybara::Selenium::Driver.new(app, args)
end

[:selenium, :mobile_selenium].each do |driver_name|
  Capybara::Screenshot.register_driver(driver_name) { |driver, path| driver.browser.save_screenshot(path) }
end

Before do
  Capybara.current_driver = :rack_test
end

Before('@javascript') do
  Capybara.current_driver = :selenium
end

Before('@mobile') do
  Capybara.current_driver = :mobile_selenium
end


if ENV['CI']
  my_ip = `hostname -i`.strip

  Capybara.server_host = my_ip

  Before do
    if Capybara.current_driver != :rack_test
      Capybara.app_host = "http://#{my_ip}:#{Capybara.current_session.server.port}"
    end
  end
end
