class Player

  def init
    log "init" 
    @player = AVPlayer.alloc.init
    add_observables
    super
  end

  def play
    @player.play
  end

  def pause
    @player.pause
  end

  def play_item(item)
    @player.replaceCurrentItemWithPlayerItem item
  end

  def dealloc
    log "dealloc"
    remove_observables
    @player = nil
  end

  private
    def observables
      ["status", "error", "rate"]
    end

    def add_observables
      observables.each do |prop|
        @player.addObserver(self, forKeyPath: prop, options: NSKeyValueObservingOptionNew, context: nil)
      end
    end

    def remove_observables
      return unless @player
      observables.each do |prop|
        @player.removeObserver(self, forKeyPath: prop) 
      end
    end

    def observeValueForKeyPath(path, ofObject: object, change: change, context: context)
      log "#{path} #{change["new"]}"

      case path
        when "error" then log(change["new"]) if change["new"]
      end
    end

end
