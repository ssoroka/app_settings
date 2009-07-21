require 'erb'
require 'yaml'

class AppSettings
  class << self
    def method_missing(m, *a, &b)
      raise Exception.new("RAILS_ENV is not defined!") unless defined?(RAILS_ENV) # handy when trying to load minimal set of libs.
      read_settings(m.to_s)
    end

    # supports AppSettings['twitter/api/keys/frank'] style settings. Wont blow up on nil keys
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
      $app_settings &&= nil
    end

    protected
      def read_settings(k, force_reload = false)
        force_reload = false # RAILS_ENV =~ /development/

        die_if_file_missing if force_reload || !$app_settings

        if force_reload || !$app_settings
          $app_settings = YAML::load(ERB.new(File.read(APP_SETTINGS_FILE)).result)[RAILS_ENV]
        end
        result = $app_settings[k]

        # check for embedded erb
        result = evaluate_embedded_erb(result)

        # if it's a hash, make it not care whether keys are strings or symbols.
        result.is_a?(Hash) ? HashWithIndifferentAccess.new(result) : result
      end

      def die_if_file_missing
        if !File.exist?(APP_SETTINGS_FILE)
          border = "\n"
          border << '*' * 60
          border << "\n"
          raise Exception.new("#{border} File #{APP_SETTINGS_FILE} does not exist. Please create it. #{border}")
        end
      end

      def evaluate_embedded_erb(result)
        case result
        when Array
          result.map{|i| evaluate_embedded_erb(i) }
        when Hash
          result.map{|k,v| {k => evaluate_embedded_erb(v)} }.inject(&:merge)
        when String
          result.scan(/\[\%\=(.*?)\%\]/).each{|match|
            result.gsub!("[%=#{match[0]}%]", instance_eval(match[0]))
          }
          result
        else
          result
        end
      end
  end
  
end