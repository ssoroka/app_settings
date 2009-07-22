require 'erb'
require 'yaml'

# see README.rdoc
class AppSettings
  class MissingConfigFileException < Exception
    def initialize(file)
      border = "\n" << ('*' * 60) << "\n"
      super("#{border} Config file #{file} does not exist. Please create it. #{border}")
    end
  end
  attr_accessor :config_file, :stored_settings
  
  # use the first config file passed in that exists. Nice for allowing users to override your default config
  # defaults to "#{RAILS_ROOT}/config/app_settings.yml" in rails apps if no config filename is passed in
  def initialize(*config_files)
    @config_file = Array(config_files).detect{|f| File.exist?(f) }
    @config_file ||= "#{RAILS_ROOT}/config/app_settings.yml" if defined?(RAILS_ROOT)
  end
  
  # allows $settings.key_name shortcut for simple structures.
  def method_missing(m, *a, &b)
    read_settings(m.to_s)
  end

  # supports $settings['twitter/api/keys/frank'] style settings. Wont blow up on nil keys
  # if RAILS_ENV is defined, it'll look for the keys in the appropriate environment inside app_settings.yml
  def [](k)
    keys = k.to_s.split('/')
    result = read_settings(keys.shift)
    while result && keys.any?
      result = result[keys.shift]
    end
    result
  end

  # immediately expires the settings caches
  def reload!
    @stored_settings &&= nil
  end
  
  protected
    def read_settings(k)
      unless @stored_settings
        die_if_file_missing
        @stored_settings = YAML::load(ERB.new(File.read(config_file)).result)
        @stored_settings = @stored_settings[RAILS_ENV] if defined?(RAILS_ENV)
      end

      @stored_settings[k.to_s]
    end

    def die_if_file_missing
      raise MissingConfigFileException.new(@config_file) if !@config_file || !File.exist?(@config_file)
    end
end