{-# LANGUAGE FlexibleContexts, ConstraintKinds, RankNTypes #-}
-- write to ~/.xmonad/xmonad.hs

import XMonad
import XMonad.Layout
import XMonad.Config.Desktop
import XMonad.Config.Gnome
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run
import XMonad.Util.EZConfig
import XMonad.Layout.Grid
import XMonad.Layout.ThreeColumns
import XMonad.Layout.Spiral
import XMonad.Layout.Circle
import System.IO

import XMonad.Hooks.EwmhDesktops (ewmh)
import System.Taffybar.Hooks.PagerHints (pagerHints)


main = do
    xmonad . ewmh . pagerHints . setupTaffyBar .  myBorders . myKeys . myHooks . myLayout . myMisc $
                desktopConfig
    -- h <- xmobarProc
    -- xmonad . setupXmobar h . myBorders . myKeys . myHooks . myLayout . myMisc $
    --             desktopConfig

{-type SetupCfg_ = ( LayoutClass l Window, Read (l Window)) => XConfig l -> XConfig l-}
-- type MyLayout = Choose Tall (Choose (Mirror Tall) Full)
-- type SetupCfg_  = XConfig MyLayout  -> XConfig MyLayout

-- myMisc :: SetupCfg_
-- myMisc cfg = cfg { terminal = "urxvt"}
myMisc cfg = cfg { terminal = "termite"}

-- myBorders :: SetupCfg_
myBorders cfg = cfg {borderWidth = 2, normalBorderColor = "#0000ff" , focusedBorderColor = "#ff0000"}

-- -- myKeys :: SetupCfg_
-- myKeys cfg = cfg {modMask = mod4Mask}  -- super instead of alt (usually Windows key)}
--                  `additionalKeys`
--                  [ ((mod4Mask, xK_q), spawn "sudo killall trayer" >> restart "xmonad" True)
--                  -- , ((mod4Mask, xK_b), sendMessage ToggleStruts)
--                  ]
myKeys cfg = cfg {modMask = mod4Mask}  -- super instead of alt (usually Windows key)}
                 `additionalKeys`
                 [ ((mod4Mask, xK_q), spawn "sudo killall trayer" >> restart "xmonad" True)
                 -- , ((mod4Mask, xK_b), sendMessage ToggleStruts)
                 ]

-- myHooks :: SetupCfg_
myHooks cfg = cfg {startupHook = startup
              -- , manageHook = manageDocks <+> manageHook defaultConfig
              -- , layoutHook = avoidStruts $ layoutHook defaultConfig
                  }

-- myLayout :: SetupCfg_
myLayout cfg = cfg {layoutHook = tiled ||| ThreeColMid 1 (5/100) (1/2) ||| spiral (6/7) ||| Mirror tiled ||| Grid ||| Circle ||| Full}
        where
            -- default tiling algorithm partitions screen into two panes
            tiled = Tall nmaster delta ratio
            -- number of windows in the master pane
            nmaster = 1
            -- default proportion of screen occupied by master pane
            ratio = 2/3
            -- percent of screen to increment when resizing
            delta = 5 / 100

xmobarProc :: IO Handle
xmobarProc = spawnPipe "/run/current-system/sw/bin/xmobar /home/handre/.xmobar/xmobarrc"

setupXmobar h cfg =
    cfg { manageHook = manageDocks <+> manageHook cfg
        , layoutHook = avoidStruts $ layoutHook cfg
        , logHook = dynamicLogWithPP xmobarPP
            { ppOutput = hPutStrLn h
            , ppTitle = xmobarColor "grey" "" . shorten 50
            , ppLayout = const "" -- to disable the layout info on xmobar
            }
        }

setupTaffyBar  cfg =
    cfg { manageHook = manageDocks <+> manageHook cfg
        , layoutHook = avoidStruts $ layoutHook cfg
        }

startup :: X()
startup = do
    -- spawn "dropbox start"
    {-spawn "trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --widthtype percent --width 10 --height 25"-}
    {-spawn "trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --widthtype percent --width 10 --height 30"-}
    spawn "dbus-launch taffybar"
    return ()
