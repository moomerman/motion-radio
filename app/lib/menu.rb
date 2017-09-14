class Menu

  def init
    @menu = NSMenu.new
    add_menu_items
    super
  end

  def items
    @menu.itemArray
  end

  def playing(name)
    set_active_menu_item(name)
    @control.title = "Pause"
    @control.image = NSImage.imageNamed("pause")
  end

  def paused(name)
    items.find{|x| x.title == name}.image = NSImage.imageNamed("speaker")
    @control.title = "Play"
    @control.image = NSImage.imageNamed("play")
  end

  def offline
    icon = NSImage.imageNamed "radio_offline"
    icon.setTemplate(false)
    @status_item.image = icon
    @control.title = @control.title + " (offline)" unless @control.title =~ /offline/
  end

  def online
    icon = NSImage.imageNamed "radio_online"
    icon.setTemplate(true)
    @status_item.image = icon
    @control.title = @control.title.gsub(" (offline)", "") if @control.title =~ /offline/
  end

  private
    def add_menu_items
      @status_item = NSStatusBar.systemStatusBar.statusItemWithLength(-1).init
      @status_item.setMenu(@menu)
      @status_item.setHighlightMode(true)

      @control = createMenuItem("Play/Pause", 'toggle')
      @menu.addItem @control

      offline

      @menu.addItem NSMenuItem.separatorItem
      Station.all.each do |name, url|
        @menu.addItem createMenuItem(name, 'station_selected:')
      end

      @menu.addItem NSMenuItem.separatorItem
      @menu.addItem createMenuItem("Quit Radio", 'quit:')
    end

    def createMenuItem(name, action)
      NSMenuItem.alloc.initWithTitle(name, action: action, keyEquivalent: '')
    end

    def set_active_menu_item(name)
      speaker = NSImage.imageNamed("speaker_playing")
      items.each{|x| x.title == name ? x.image = speaker : x.image = nil }
    end
end
