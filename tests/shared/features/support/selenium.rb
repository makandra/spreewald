Capybara.register_driver :selenium do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--headless') unless ENV.key?('NO_HEADLESS')
  options.add_argument('--disable-infobars')
  # options.add_option('w3c', false)
  options.add_emulation(device_metrics: { width: 1280, height: 960, touch: false })
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end

Selenium::WebDriver.logger.level = :error
