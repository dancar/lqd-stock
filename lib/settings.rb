require 'yaml'

SETTINGS_FILE = './settings.yml'
LOCAL_SETTINGS_FILE = './settings_local.yml'
# TODO: check files exists

class Settings

  def self.[](k)
    init unless @settings
    @settings[k]
  end

  def self.init(settings_file = SETTINGS_FILE,
                local_settings_file = LOCAL_SETTINGS_FILE)
    base_settings = YAML.load_file(settings_file)
    local_settings = YAML.load_file(local_settings_file)
    @settings = self.symbolize_keys(
      self.simple_deep_merge(
        base_settings, local_settings))
  end

  def self.symbolize_keys(hash)
    return hash if hash.class != Hash
    return Hash[hash.map {|k,v| [k.to_sym, self.symbolize_keys(v)]}]
  end

  def self.simple_deep_merge(base_hash, override_hash)
    # A deep merge which assumes override_hash is a nested subset of base_hash
    ans = base_hash.clone
    override_hash.each do |k, v|
      ans[k] = v.class == Hash ? self.simple_deep_merge(ans[k], v) : v
    end
    return ans
  end
end
