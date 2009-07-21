require 'spec'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
RAILS_ENV = 'test'

require 'app_settings'

Spec::Runner.configure do |config|
  AppSettings::APP_SETTINGS_FILE = File.join(File.dirname(__FILE__), %w(.. example_config app_settings.yml))
  
end
