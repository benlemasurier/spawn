import XMonad
import XMonad.Config.Desktop
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.EwmhDesktops
import XMonad.Layout.Fullscreen
import XMonad.Layout.NoBorders
import XMonad.Layout.Spacing
import XMonad.Layout.ThreeColumns
import XMonad.Layout.Grid
import XMonad.Layout.Reflect
import XMonad.Layout.MultiToggle
import XMonad.Util.NamedWindows
import XMonad.Util.NamedScratchpad
import XMonad.Util.EZConfig
import XMonad.Util.Run

scratchpads = [
    NS "notebook" "alacritty  --title notebook --class notebook -e nvim -c VimwikiIndex"
        (title =? "notebook") defaultFloating ,
    NS "scratchpad" "alacritty  --title scratchpad --class scratchpad"
        (title =? "scratchpad") defaultFloating
    ]

myManageHook :: ManageHook
myManageHook = composeAll
    [ resource  =? "desktop_window" --> doIgnore
    , className =? "gimp"           --> doFloat
    , className =? "kicad"          --> doFloat
    , isDialog			    --> doFloat
    , isFullscreen		    --> doFullFloat
    ]

mySpacing = spacingRaw True              -- only for >1 window
                       (Border 0 0 0 0)  -- screen border: top, bottom, right, left
                       True              -- enable screen edge gaps
                       (Border 2 2 2 2)  -- window gap: top, bottom, right, left
                       True              -- enable window gaps

layout = avoidStruts (
    mkToggle (single REFLECTX) $
    mkToggle (single REFLECTY) $
    mySpacing $ 
        Tall 1 (3/100) (1/2) |||
        Tall 1 (3/100) (1/2) |||
        ThreeColMid 1 (3/100) (1/2) |||
        Full |||
        Grid)

cfg = desktopConfig {
        terminal           = "alacritty",
        borderWidth        = 1,
        normalBorderColor  = "#2c3642",
        focusedBorderColor = "#8ecae6",

        -- hooks
        manageHook         = myManageHook,
        layoutHook         = smartBorders $ layout 
        } `additionalKeysP`
        [ ("M-s",   namedScratchpadAction scratchpads "scratchpad")
        , ("M-i",   namedScratchpadAction scratchpads "notebook")
        , ("M-S-l", unsafeSpawn "xwobf /tmp/.lock.png && i3lock -i /tmp/.lock.png")
        , ("M-p",   safeSpawn "rofi" ["-show", "run"])
        , ("M-S-p", safeSpawn "rofi-pass" [])
        , ("M-x",   sendMessage $ Toggle REFLECTX)
        , ("M-y",   sendMessage $ Toggle REFLECTY)
        ]

main :: IO ()
main = do
    -- apply this config over the default
    xmonad
        $ docks

        -- extended window manager hints compliance
        $ ewmhFullscreen
        $ ewmh

        $ cfg 
