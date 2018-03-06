require 'yaml'

# TODO: check files exists

class Settings
  SETTINGS_FILE = './settings.yml'
  def self.[](k)
    init unless @settings
    @settings[k]
  end

  def self.init(settings_file = SETTINGS_FILE)
    @settings = self.symbolize_keys(YAML.load_file(settings_file))
  end

  def self.symbolize_keys(hash)
    return hash if hash.class != Hash
    return Hash[hash.map {|k,v| [k.to_sym, self.symbolize_keys(v)]}]
  end
end
