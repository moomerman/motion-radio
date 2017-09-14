# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/osx'

require 'bundler'
Bundler.require

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'Radio'
  app.icon = 'radio.icns'
  app.identifier = 'com.moocode.osx.Radio'
  app.info_plist['LSUIElement'] = true
  app.frameworks += ['AVFoundation', 'ServiceManagement']

  app.sdk_version = '10.12'
  app.deployment_target = '10.12'

  app.vendor_project('vendor/SPMediaKeyTap', :static)

  app.info_plist['NSMainNibFile'] = 'MainMenu'
  app.info_plist['NSAppTransportSecurity'] = {
    'NSAllowsArbitraryLoads' => true
  }

  app.pods do
    pod "Reachability"
  end

  app.release do
    app.codesign_certificate = "Developer ID Application: Moocode Ltd. (B3JURKS5LT)"
  end
end
