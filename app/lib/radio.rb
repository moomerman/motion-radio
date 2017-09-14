class Radio
  attr_reader :station

  def self.instance
    Dispatch.once { @instance ||= alloc.init }
    @instance
  end

  def init
    log "init"
    @player = Player.alloc.init
    super
  end

  def play
    log "play"
    autotune unless @station
    @player.play
    @playing = true
  end

  def pause
    log "pause"
    @player.pause
    @playing = false
  end

  def autotune
    log "autotune"
    tune(Station.all.keys.sample)
  end

  def tune(station)
    log "tune '#{station}'"
    @station = Station.get(station)
    @player.play_item(@station.station)
  end

  def playing?
    @playing
  end

end
