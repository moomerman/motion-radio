class Preference
  class << self

    def set(key, data)
      NSUserDefaults.standardUserDefaults[key] = data
      NSUserDefaults.standardUserDefaults.synchronize
    end

    def get(key)
      NSUserDefaults.standardUserDefaults[key]
    end

  end
end
