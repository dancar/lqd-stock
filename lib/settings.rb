require 'yaml'

SETTINGS_FILE = './settings.yml'
LOCAL_SETTINGS_FILE = './settings_local.yml'

class Settings < Hash
  def initialize()
    super()
    base_settings = YAML.load_file(SETTINGS_FILE)
    local_settings = YAML.load_file(LOCAL_SETTINGS_FILE)
    self.merge!(
      symbolize_keys(
        simple_deep_merge(base_settings, local_settings)))
  end

  def symbolize_keys(hash)
    return hash if hash.class != Hash
    return Hash[hash.map {|k,v| [k.to_sym, symbolize_keys(v)]}]
  end

  def simple_deep_merge(base_hash, override_hash)
    # A deep merge which assumes override_hash is a nested subset of base_hash
    ans = base_hash.clone
    override_hash.each do |k, v|
      ans[k] = v.class == Hash ? simple_deep_merge(ans[k], v) : v
    end
    return ans
  end
end
