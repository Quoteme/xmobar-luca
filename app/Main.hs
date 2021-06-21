module Main where

import Xmobar
import Plugins

-- CONFIG
config :: Config
config = defaultConfig {
  font = "xft:scientifica:size=9:antialias=false"
  , additionalFonts = ["xft:siji:size=9:antialias=false"]
  , borderColor = "black"
  , border = BottomB
  , bgColor = "black"
  , fgColor = "#646464"
  , alpha = 255
  , position = Top
  , textOffset = -1
  , iconOffset = -1
  , lowerOnStart = True
  , pickBroadest = False
  , persistent = True
  , hideOnStart = False
  , iconRoot = ".xmonad/xmobar-luca/res/icon/"
  , allDesktops = True
  , overrideRedirect = True
  , commands = [
    Run $ DynNetwork [ "--template" , "<action='networkmanager_dmenu' button=1><icon=wifi.xpm/> <tx>kB/s|<rx>kB/s</action>"
      , "--Low"      , "1000"       -- units: B/s
      , "--High"     , "5000"       -- units: B/s
      , "--low"      , "darkgreen"
      , "--normal"   , "darkorange"
      , "--high"     , "darkred"
      ] 10
    , Run $ MultiCpu [ "--template" , "<icon=cpu.xpm/> <total0>%|<total1>%"
      , "--Low"      , "50"         -- units: %
      , "--High"     , "85"         -- units: %
      , "--low"      , "darkgreen"
      , "--normal"   , "darkorange"
      , "--high"     , "darkred"
      ] 10
    , Run $ CoreTemp [ "--template" , "<icon=temperature.xpm/> <core0>°C|<core1>°C"
      , "--Low"      , "70"        -- units: °C
      , "--High"     , "80"        -- units: °C
      , "--low"      , "darkgreen"
      , "--normal"   , "darkorange"
      , "--high"     , "darkred"
      ] 50
    , Run $ Memory   [ "--template" ,"<icon=ram.xpm/> <usedratio>%"
      , "--Low"      , "20"        -- units: %
      , "--High"     , "90"        -- units: %
      , "--low"      , "darkgreen"
      , "--normal"   , "darkorange"
      , "--high"     , "darkred"
      ] 10
    , Run $ Battery  [ "--template" , "<acstatus>"
      , "--Low"      , "10"        -- units: %
      , "--High"     , "80"        -- units: %
      , "--low"      , "darkred"
      , "--normal"   , "darkorange"
      , "--high"     , "darkgreen"
      , "--" -- battery specific options
      -- discharging status
      , "-o" , "<icon=batteryDrainHalf.xpm/><left>% (<timeleft>)"
      -- AC "on" status
      , "-O" , "<icon=batteryCharging.xpm/><fc=#dAA520>Charging</fc>"
      -- charged status
      , "-i" , "<icon=batteryCharged.xpm/>"
      ] 50
    , Run $ Date           "<fc=#ABABAB>%d/%m/%y %H:%M</fc>" "date" 10
    , Run StdinReader
    , Run UnsafeStdinReader
    , Run Volume
    , Run Light
    , Run Speech
    , Run Screenshot
    , Run WindowMenu
    ]
  , sepChar = "%"
  , alignSep = "}{"
  , template = "%UnsafeStdinReader%}{%battery% | %dynnetwork% | %multicpu% | %coretemp% | %memory% | %date% | %Light% %Volume% | %Speech% %Screenshot% | %WindowMenu%"
  -- , template = "%UnsafeStdinReader%}{%Volume%"
--
}

main :: IO ()
main = xmobar config
