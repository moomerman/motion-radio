class AppDelegate
  attr_accessor :menu, :radio

  def applicationDidFinishLaunching(notification)
    @app_name = NSBundle.mainBundle.infoDictionary['CFBundleDisplayName']
    @menu = Menu.alloc.init

    register_for_media_key_events
    start_reachability
    start_radio
  end

  def register_for_media_key_events
    media_key_tap = SPMediaKeyTap.alloc.initWithDelegate self
    if SPMediaKeyTap.usesGlobalMediaKeyTap
      log "watching media keys"
      media_key_tap.startWatchingMediaKeys
    else
      log "media key monitoring disabled"
    end
  end

  def start_reachability
    @reachability = Reachability.reachabilityWithHostname "www.google.com"

    NSNotificationCenter.defaultCenter.addObserver(self,
      selector: "reachabilityChanged:",
      name: KReachabilityChangedNotification,
      object: nil
    )

    log "starting reachability notifier"
    @reachability.startNotifier
  end

  def start_radio
    @radio = Radio.instance
    play
  end

  def play
    @radio.play
    @menu.playing(@radio.station.name)
  end

  def pause
    @radio.pause
    @menu.paused(@radio.station.name)
  end

  def toggle
    @radio.playing? ? pause : play
  end

  def station_selected(item)
    change_station(item.title)
  end

  def change_station(name)
    @radio.tune(name)
    play
  end

  def random_station
    @radio.autotune
    play
  end

  def quit(menu_item)
    log menu_item
    pause
    NSApp.terminate(self)
  end

  # delegates

  def reachabilityChanged(notification)
    if @reachability.isReachable
      log "reachable"
      change_station(@radio.station.name) if @reachable == false and !@radio.playing?
      @reachable = true
      @menu.online
    else
      log "unreachable"
      pause if @reachable == true and @radio.playing?
      @reachable = false
      @menu.offline
    end
  end

  def mediaKeyTap(media_tap, receivedMediaKeyEvent: event)
    log "Unexpected NSEvent in mediaKeyTap:receivedMediaKeyEvent:" unless (event.type == NSSystemDefined and event.subtype == SPSystemDefinedEventMediaKeys)

    key_code = (event.data1 & 0xFFFF0000) >> 16
    key_flags = event.data1 & 0x0000FFFF
    key_is_pressed = ((key_flags & 0xFF00) >> 8) == 0xA
    key_repeat = key_flags & 0x1

    if key_is_pressed

      case key_code
        when 16 then log("play/pause"); toggle
        when 19 then log("forward"); random_station
        when 20 then log("back"); random_station
        else log("unknown media key pressed #{key_code}")
      end

    end
  end
end
