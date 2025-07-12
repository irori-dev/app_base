RSpec.configure do |config|
  config.before(:each, type: :system) do
    if ENV['CI']
      driven_by :selenium_chrome_headless
    else
      driven_by :remote_chrome
      Capybara.server_host = IPSocket.getaddress(Socket.gethostname)
      Capybara.server_port = 4444
      Capybara.app_host = "http://#{Capybara.server_host}:#{Capybara.server_port}"
    end
  end

  config.before(:each, type: :system, js: true) do
    if ENV['CI']
      driven_by :selenium_chrome_headless
    else
      driven_by :remote_chrome
      Capybara.server_host = IPSocket.getaddress(Socket.gethostname)
      Capybara.server_port = 4444
      Capybara.app_host = "http://#{Capybara.server_host}:#{Capybara.server_port}"
    end
  end
end

# Chrome for Docker environment
Capybara.register_driver :remote_chrome do |app|
  url = 'http://chrome:4444/wd/hub'
  caps = Selenium::WebDriver::Remote::Capabilities.chrome(
    'goog:chromeOptions' => {
      'args' => [
        'no-sandbox',
        'headless',
        'disable-gpu',
        'window-size=1680,1050',
      ],
    }
  )
  Capybara::Selenium::Driver.new(app, browser: :remote, url:, capabilities: caps)
end

# Chrome for CI environment
Capybara.register_driver :selenium_chrome_headless do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--headless')
  options.add_argument('--no-sandbox')
  options.add_argument('--disable-dev-shm-usage')
  options.add_argument('--disable-gpu')
  options.add_argument('--window-size=1680,1050')
  
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end
