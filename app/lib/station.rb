class Station
  attr_reader :name, :station

  def self.all
    {
      "BBC Radio 1" => "http://a.files.bbci.co.uk/media/live/manifesto/audio/simulcast/hls/uk/sbr_high/ak/bbc_radio_one.m3u8",
      "BBC Radio 1Xtra" => "http://a.files.bbci.co.uk/media/live/manifesto/audio/simulcast/hls/uk/sbr_high/ak/bbc_1xtra.m3u8",
      "BBC Radio 2" => "http://a.files.bbci.co.uk/media/live/manifesto/audio/simulcast/hls/uk/sbr_high/ak/bbc_radio_two.m3u8",
      "BBC Radio 3" => "http://a.files.bbci.co.uk/media/live/manifesto/audio/simulcast/hls/uk/sbr_high/ak/bbc_radio_three.m3u8",
      "BBC Radio 4" => "http://a.files.bbci.co.uk/media/live/manifesto/audio/simulcast/hls/uk/sbr_high/ak/bbc_radio_fourfm.m3u8",
      "BBC Radio 5 Live" => "http://a.files.bbci.co.uk/media/live/manifesto/audio/simulcast/hls/uk/sbr_high/ak/bbc_radio_five_live.m3u8",
      "BBC 6 Music" => "http://a.files.bbci.co.uk/media/live/manifesto/audio/simulcast/hls/uk/sbr_high/llnw/bbc_6music.m3u8",
      "Absolute Radio" => "http://network.absoluteradio.co.uk/core/audio/aacplus/live.pls?service=arhq",
      "Absolute Classic Rock" => "http://network.absoluteradio.co.uk/core/audio/aacplus/live.pls?service=achq",
      "Absolute Radio 60s" => "http://network.absoluteradio.co.uk/core/audio/aacplus/live.pls?service=a6hq",
      "Absolute Radio 70s" => "http://network.absoluteradio.co.uk/core/audio/aacplus/live.pls?service=a7hq",
      "Absolute Radio 80s" => "http://network.absoluteradio.co.uk/core/audio/aacplus/live.pls?service=a8hq",
      "Absolute Radio 90s" => "http://network.absoluteradio.co.uk/core/audio/aacplus/live.pls?service=a9hq",
      "Absolute Radio 00s" => "http://network.absoluteradio.co.uk/core/audio/aacplus/live.pls?service=a0hq",
      "Radio City" => "http://tx.whatson.com/icecast.php?i=city.mp3.m3u",
      "Radio X" => 'http://media-ice.musicradio.com/RadioXLondonMP3.m3u',
      "Soho Radio" => 'http://149.202.90.221:9036'
    }
  end

  def self.get(name)
    alloc.init_name(name)
  end

  def self.random
    get all.keys.sample
  end

  def init_name(name)
    @name = name
    @url = NSURL.alloc.initWithString Station.all[name]
    @station = AVPlayerItem.alloc.initWithURL @url
    add_observables
    init
  end

  def dealloc
    log "dealloc"
    remove_observables
    @station = nil
  end

  private
    def observables
      ["status", "error", "playbackLikelyToKeepUp", "playbackBufferEmpty", "playbackBufferFull"]
    end

    def add_observables
      observables.each do |prop|
        @station.addObserver(self, forKeyPath: prop, options: NSKeyValueObservingOptionNew, context: nil)
      end
    end

    def remove_observables
      return unless @station
      observables.each do |prop|
        @station.removeObserver(self, forKeyPath: prop)
      end
    end

    def observeValueForKeyPath(path, ofObject: object, change: change, context: context)
      log "#{path} #{change["new"]}"

      case path
        when "error" then log(change["new"]) if change["new"]
      end
    end

end
