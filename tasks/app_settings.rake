namespace :app_settings do
  desc "Install the default config file"
  task :install_config => [:environment] do
    if File.exist?(AppSettings::APP_SETTINGS_FILE)
      puts "#{AppSettings::APP_SETTINGS_FILE} already exists.  Remove it first if you want to overwrite it."
    else
      puts "installing default config file to #{AppSettings::APP_SETTINGS_FILE}"
      FileUtils.mv(File.join(File.dirname(__FILE__), %w(.. example_config app_settings.yml)), AppSettings::APP_SETTINGS_FILE)
    end
  end
end

