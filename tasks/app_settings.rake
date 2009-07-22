namespace :app_settings do
  desc "Install the default config file"
  task :install_config => [:environment] do
    dest_file = File.join(Rails.root, 'config', 'app_settings.yml')
    if File.exist?(dest_file)
      puts "#{dest_file} already exists.  Remove it first if you want to overwrite it."
    else
      puts "installing default config file to #{dest_file}"
      FileUtils.mv(File.join(File.dirname(__FILE__), %w(.. example_config example_for_rails.yml)), dest_file)
    end
  end
end

