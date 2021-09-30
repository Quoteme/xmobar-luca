module Plugins where

import Xmobar
import System.Process (readProcess)

data VolumeBar = VolumeBar
  deriving (Read, Show)
instance Exec VolumeBar where
  rate VolumeBar = 5
  run VolumeBar = do
    vol <- readProcess "pamixer" ["--get-volume"] []
    return (slider (parse vol) 100 10 setVolume "#" "·")
    where
      parse v = read (takeWhile (/='%') v) :: Int
      setVolume v = "pamixer --set-volume "++show (10*v)
      -- setVolume v = callProcess "pamixer" ["--set-volume",show v]

data LightBar = LightBar
  deriving (Read, Show)
instance Exec LightBar where
  rate LightBar = 5
  run LightBar = do
    light <- readProcess "light" [] []
    return (slider (parse light) 100 10 setLightBar "#" "·")
      where
        parse v = round (read v :: Float)
        setLightBar v = "light -S "++show (10*v)

data Screenshot = Screenshot
  deriving (Read, Show)
instance Exec Screenshot where
  run Screenshot = return (action "maim -u -s | xclip -selection clipboard -t image/png" (icon "camera.xpm"))

data Speech = Speech
  deriving (Read, Show)
instance Exec Speech where
  run Speech = return (action "~/.xmonad/xmobar-luca/res/speech/speech.py" (icon "microphone.xpm"))

data WindowMenu = WindowMenu
  deriving (Read, Show)
instance Exec WindowMenu where
  run WindowMenu = return (action "sleep 0.7 && xmonadctl \"menu\"" (icon "menu.xpm"))

-- PLUGIN Utility functions
slider :: Int -> Int -> Int -> (Int -> String) -> String -> String -> String
slider value total width fun filledSymbol emptySymbol = wrap "<" ">" bar
  where
    percentage = fromIntegral value / fromIntegral total
    filledSize = ceiling (fromIntegral width * percentage)
    -- bar = replicate filledSize 'X' ++ replicate (width - filledSize) '-'
    symbol i = if i<filledSize then filledSymbol else emptySymbol
    bar = concat [ action (fun i) (symbol i) | i<-[0..width-1] ]

wrap :: String -> String -> String -> String
wrap a1 a2 b = a1 <> b <> a2

action :: String -> String -> String
action command = wrap ("<action="++command++">") "</action>"

icon :: String -> String
icon ico = "<icon="++ico++"/>"
