{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE ConstraintKinds #-}
{-# LANGUAGE RankNTypes #-}

import System.Taffybar.Support.PagerHints  (pagerHints)
import XMonad
import XMonad.Config.Desktop
import XMonad.Hooks.EwmhDesktops (ewmh)
import XMonad.Hooks.ManageDocks (AvoidStruts, avoidStruts, docks)
import XMonad.Layout.Grid
import XMonad.Layout.LayoutModifier (ModifiedLayout)
import XMonad.Layout.ThreeColumns
import XMonad.Util.EZConfig
import XMonad.Hooks.ManageHelpers -- (composeOne, (-?>), transience)
import XMonad.StackSet  hiding (filter)
import Control.Monad
import Data.Monoid
import XMonad.Hooks.PositionStoreHooks
import XMonad.Actions.Navigation2D
import XMonad.Util.NamedActions
import qualified XMonad.StackSet as W
import qualified Data.Map as M
import XMonad.Util.Paste as P               -- testing
import XMonad.Actions.CopyWindow
import XMonad.Layout.ResizableTile
import XMonad.Layout.BinarySpacePartition
import XMonad.Layout.Reflect
import XMonad.Actions.SinkAll
import XMonad.Layout.SubLayouts
import XMonad.Actions.DynamicWorkspaceOrder
import XMonad.Actions.CycleWS
import XMonad.Prompt
import XMonad.Layout.MultiToggle.Instances
import XMonad.Actions.DynamicProjects
import XMonad.Actions.Promote
import XMonad.Layout.Hidden
import XMonad.Actions.WithAll
import XMonad.Hooks.UrgencyHook
import XMonad.Layout.Decoration
import XMonad.Layout.ShowWName
import XMonad.Prompt.ConfirmPrompt
import System.Exit
import XMonad.Util.XSelection
import XMonad.Actions.MessageFeedback
import XMonad.Util.Run
import XMonad.Util.WorkspaceCompare
import GHC.IO.Handle
import qualified XMonad.Layout.Renamed
import XMonad.Layout.PerScreen
import XMonad.Layout.Accordion
import XMonad.Layout.Simplest
import XMonad.Layout.Tabbed
import XMonad.Layout.WindowNavigation
import XMonad.Layout.Gaps
import XMonad.Layout.Spacing
import XMonad.Layout.NoFrillsDecoration
import XMonad.Layout.Renamed
import XMonad.Layout.MultiToggle
import XMonad.Layout.SimplestFloat
import XMonad.Layout.Fullscreen
import XMonad.Layout.PerWorkspace
import XMonad.Actions.SpawnOn

main :: IO ()
main =
  xmonad .
  dynamicProjects projects .
  withNavigation2DConfig myNav2DConf .
  {-floatPlacements .-}
  myManageHooks .
  myLayout .
  pagerHints .
  myBorders .
  myKeys' .
  myHooks .
  myMisc .
  docks .
  ewmh $
  desktopConfig


myManageHooks :: XConfig l -> XConfig l
myManageHooks cfg =
  cfg
    { manageHook = composeOne
        [  transientTo >>=  maybe (pure Nothing) moveIt
        ] <+> manageHook cfg
    }
  where
    moveIt :: Window -> Query (Maybe (Data.Monoid.Endo WindowSet))
    moveIt _ = Just <$> doRectFloat (RationalRect 0.25 0.25 0.25 0.25)


myMisc :: XConfig l -> XConfig l
myMisc cfg = cfg {terminal = myTerminal, XMonad.workspaces = myWorkspaces}

myBorders :: XConfig l -> XConfig l
myBorders cfg =
  cfg
  { borderWidth = border
  , normalBorderColor = myNormalBorderColor
  , focusedBorderColor = myFocusedBorderColor
  }

myKeys' :: XConfig l -> XConfig l
myKeys' =
  addDescrKeys' ((myModMask, xK_F1), showKeybindings) myKeys .
  (\cfg -> cfg {modMask = myModMask})

myHooks :: XConfig l -> XConfig l
myHooks cfg = cfg {startupHook = startup <+> startupHook cfg}

myLayout cfg = cfg{layoutHook = myLayoutHook}

startup :: X()
startup = do
  spawn "dbus-launch taffybar"
  return ()

------------------------------------------------------------------------}}}
-- Layouts                                                              {{{
--
-- WARNING: WORK IN PROGRESS AND A LITTLE MESSY
---------------------------------------------------------------------------

-- Tell X.A.Navigation2D about specific layouts and how to handle them

myNav2DConf = def
    { defaultTiledNavigation    = centerNavigation
    , floatNavigation           = centerNavigation
    , screenNavigation          = lineNavigation
    , layoutNavigation          = [("Full",          centerNavigation)
                                  ]
    , unmappedWindowRect        = [("Full", singleWindowRect)
                                  ]
    }

data FULLBAR = FULLBAR deriving (Read, Show, Eq, Typeable)
instance Transformer FULLBAR Window where
    transform FULLBAR x k = k barFull (const x)

-- tabBarFull = avoidStruts $ noFrillsDeco shrinkText topBarTheme $ addTabs shrinkText myTabTheme $ Simplest
barFull :: ModifiedLayout AvoidStruts Simplest a
barFull = avoidStruts Simplest

-- cf http://xmonad.org/xmonad-docs/xmonad-contrib/src/XMonad-Config-Droundy.html
myLayoutHook = showWorkspaceName
             $ onWorkspace wsFloat floatWorkSpace
             $ fullscreenFloat -- fixes floating windows going full screen, while retaining "bounded" fullscreen
             $ fullScreenToggle
             $ fullBarToggle
             $ mirrorToggle
             $ reflectToggle
             $ tall ||| bsp ||| threeCol ||| grid
  where

    floatWorkSpace      = simplestFloat
    fullBarToggle       = mkToggle (single FULLBAR)
    fullScreenToggle    = mkToggle (single FULL)
    mirrorToggle        = mkToggle (single MIRROR)
    reflectToggle       = mkToggle (single REFLECTX)
    smallMonResWidth    = 1920
    showWorkspaceName   = showWName' myShowWNameTheme

    named n             = renamed [XMonad.Layout.Renamed.Replace n]
    trimNamed w n       = renamed [XMonad.Layout.Renamed.CutWordsLeft w,
                                   XMonad.Layout.Renamed.PrependWords n]
    suffixed n          = renamed [XMonad.Layout.Renamed.AppendWords n]
    trimSuffixed w n    = renamed [XMonad.Layout.Renamed.CutWordsRight w,
                                   XMonad.Layout.Renamed.AppendWords n]

    addTopBar           = noFrillsDeco shrinkText topBarTheme

    mySpacing           = spacing gap
    myGaps              = gaps [(U, gap),(D, gap),(L, gap),(R, gap)]

    --------------------------------------------------------------------------
    -- Tabs Layout                                                          --
    --------------------------------------------------------------------------
    common n = named n
         . avoidStruts
         -- don't forget: even though we are using X.A.Navigation2D
         -- we need windowNavigation for merging to sublayouts
         . windowNavigation
         . addTopBar
         . addTabs shrinkText myTabTheme
         . subLayout [] (Simplest ||| Accordion ||| Grid)
         . myGaps
         . mySpacing

    threeCol =
        common "3 col" $
        ThreeColMid 1 (1/100) (1/2)

    tall =
        common "Tall" $
        Tall nmaster delta ratio
    bsp =
        common "BSP" $
        hiddenWindows emptyBSP
    grid =
        common "Grid" Grid

      -- number of windows in the master pane
    nmaster = 1
      -- default proportion of screen occupied by master pane
    ratio = 2 / 3
      -- percent of screen to increment when resizing
    delta = 1 / 100



------------------------------------------------------------------------}}}
-- Bindings                                                             {{{
---------------------------------------------------------------------------

myModMask = mod4Mask -- super (and on my system, hyper) keys

-- Display keyboard mappings using zenity
-- from https://github.com/thomasf/dotfiles-thomasf-xmonad/
--              blob/master/.xmonad/lib/XMonad/Config/A00001.hs
showKeybindings :: [((KeyMask, KeySym), NamedAction)] -> NamedAction
showKeybindings x = addName "Show Keybindings" $ io $ do
    h <- spawnPipe "zenity --text-info --font=terminus"
    hPutStr h (unlines $ showKm x)
    hClose h
    return ()

-- some of the structure of the following cribbed from
-- https://github.com/SimSaladin/configs/blob/master/.xmonad/xmonad.hs
-- https://github.com/paul-axe/dotfiles/blob/master/.xmonad/xmonad.hs
-- https://github.com/pjones/xmonadrc (+ all the dyn project stuff)

-- wsKeys = map (\x -> "; " ++ [x]) ['1'..'9']
-- this along with workspace section below results in something link
-- M1-semicolon         1 View      ws
-- M1-semicolon         2 View      ws
-- M1-Shift-semicolon   1 Move w to ws
-- M1-Shift-semicolon   2 Move w to ws
-- M1-C-Shift-semicolon 1 Copy w to ws
-- M1-C-Shift-semicolon 2 Copy w to ws

wsKeys = map show $ [1..9] ++ [0]

-- any workspace but scratchpad
notSP = (return $ ("NSP" /=) . W.tag) :: X (WindowSpace -> Bool)
shiftAndView dir = findWorkspace getSortByIndex dir (WSIs notSP) 1
        >>= \t -> (windows . W.shift $ t) >> (windows . W.greedyView $ t)


myKeys :: XConfig Layout -> [((KeyMask, KeySym), NamedAction)]
myKeys conf = let

    subKeys str ks = subtitle str : mkNamedKeymap conf ks
    dirKeys        = ["j","k","h","l"]
    arrowKeys        = ["<D>","<U>","<L>","<R>"]
    dirs           = [ D,  U,  L,  R ]

    --screenAction f        = screenWorkspace >=> flip whenJust (windows . f)

    zipM  m nm ks as f = zipWith (\k d -> (m ++ k, addName nm $ f d)) ks as
    zipM' m nm ks as f b = zipWith (\k d -> (m ++ k, addName nm $ f d b)) ks as


    -- try sending one message, fallback if unreceived, then refresh
    tryMsgR x y = sequence_ [tryMessageWithNoRefreshToCurrent x y, refresh]


    toggleFloat w = windows (\s -> if M.member w (W.floating s)
                    then W.sink w s
                    else W.float w (W.RationalRect (1/3) (1/4) (1/2) (4/5)) s)

    in

    -----------------------------------------------------------------------
    -- System / Utilities
    -----------------------------------------------------------------------
    subKeys "System"
    [ ("M-q"                    , addName "Restart XMonad"                  $ spawn "xmonad --restart")
    , ("M-C-q"                  , addName "Rebuild & restart XMonad"        $ spawn "xmonad --recompile && xmonad --restart")
    , ("M-S-q"                  , addName "Quit XMonad"                     $ confirmPrompt hotPromptTheme "Quit XMonad" $ io exitSuccess)
    , ("M-x"                    , addName "Lock screen"                     $ spawn "xset s activate")
    , ("M-<F4>"                 , addName "Print Screen"                    $ return ())
    ] ^++^

    -- -----------------------------------------------------------------------
    -- -- Launchers
    -- -----------------------------------------------------------------------
    subKeys "Launchers"
    [ ("M-<Space>"              , addName "Launcher"                        $ spawn myLauncher)
    , ("M-<Return>"             , addName "Terminal"                        $ spawn myTerminal)
    ] ^++^

    -----------------------------------------------------------------------
    -- Windows
    -----------------------------------------------------------------------

    subKeys "Windows"
    (
    [ ("M-<Backspace>"          , addName "Kill"                            kill1)
    , ("M-S-<Backspace>"        , addName "Kill all"                        $ confirmPrompt hotPromptTheme "kill all" killAll)
    , ("M-d"                    , addName "Duplicate w to all ws"            toggleCopyToAll)
    {-, ("M-p"                    , addName "Hide window to stack"            $ withFocused hideWindow)-}
    {-, ("M-S-p"                  , addName "Restore hidden window (FIFO)"     popOldestHiddenWindow)-}

    , ("M-b"                    , addName "Promote"                          promote)

    , ("M-g"                    , addName "Un-merge from sublayout"         $ withFocused (sendMessage . UnMerge))
    , ("M-S-g"                  , addName "Merge all into sublayout"        $ withFocused (sendMessage . MergeAll))

    , ("M-z u"                  , addName "Focus urgent"                    focusUrgent)
    , ("M-z m"                  , addName "Focus master"                    $ windows W.focusMaster)

    , ("M-'"                    , addName "Swap tab D"                      $ onGroup focusDown')
    , ("M-;"                    , addName "Swap tab U"                      $ onGroup focusUp')

    ]

    ++ zipM' "M-"               "Navigate window"                           dirKeys dirs windowGo True
    ++ zipM' "M-S-"             "Move window"                               dirKeys dirs windowSwap True
    ++ zipM  "M-C-"             "Merge w/sublayout"                         dirKeys dirs (sendMessage . pullGroup)
    ++ zipM' "M-"               "Navigate screen"                           arrowKeys dirs screenGo True
    ++ zipM' "M-C-"             "Move window to screen"                     arrowKeys dirs windowToScreen True
    ++ zipM' "M-S-"             "Swap workspace to screen"                  arrowKeys dirs screenSwap True

    ) ^++^

    -----------------------------------------------------------------------
    -- Workspaces & Projects
    -----------------------------------------------------------------------

    -- original version was for dynamic workspaces
    --    subKeys "{a,o,e,u,i,d,...} focus and move window between workspaces"
    --    (  zipMod "View      ws" wsKeys [0..] "M-"      (withNthWorkspace W.greedyView)

    subKeys "Workspaces & Projects"
    (
    [ ("M-w"                    , addName "Switch to Project"           $ switchProjectPrompt warmPromptTheme)
    , ("M-S-w"                  , addName "Shift to Project"            $ shiftToProjectPrompt warmPromptTheme)
    -- , ("M-<Escape>"             , addName "Next non-empty workspace"    $ nextNonEmptyWS)
    -- , ("M-S-<Escape>"           , addName "Prev non-empty workspace"    $ prevNonEmptyWS)
    -- , ("M-`"                    , addName "Next non-empty workspace"    $ nextNonEmptyWS)
    -- , ("M-S-`"                  , addName "Prev non-empty workspace"    $ prevNonEmptyWS)
    , ("M-a"                    , addName "Toggle last workspace"       $ toggleWS' ["NSP"])
    ]
    ++ zipM "M-"                "View      ws"                          wsKeys [0..9] (\i -> switchProject (projects !! i))
    ++ zipM "M-S-"              "Move w to ws"                          wsKeys [0..9] (\i -> shiftToProject (projects !! i))
    -- TODO: following may necessitate use of a "passthrough" binding that can send C- values to focused w
    {-++ zipM "C-"                "Move w to ws"                          wsKeys [0..] (withNthWorkspace W.shift)-}
    -- TODO: make following a submap
    ++ zipM "M-S-C-"            "Copy w to ws"                          wsKeys [0..] (withNthWorkspace copy)
    ) ^++^

    -- TODO: consider a submap for nav/move to specific workspaces based on first initial

    -----------------------------------------------------------------------
    -- Layouts & Sublayouts
    -----------------------------------------------------------------------

    subKeys "Layout Management"

    [ ("M-<Tab>"                , addName "Cycle all layouts"               $ sendMessage NextLayout)
    , ("M-C-<Tab>"              , addName "Cycle sublayout"                 $ toSubl NextLayout)
    , ("M-S-<Tab>"              , addName "Reset layout"                    $ setLayout $ XMonad.layoutHook conf)

    , ("M-y"                    , addName "Float tiled w"                   $ withFocused toggleFloat)
    , ("M-S-y"                  , addName "Tile all floating w"             $ sinkAll)

    , ("M-,"                    , addName "Decrease master windows"         $ sendMessage (IncMasterN (-1)))
    , ("M-."                    , addName "Increase master windows"         $ sendMessage (IncMasterN 1))

    , ("M-r"                    , addName "Reflect/Rotate"              $ tryMsgR (Rotate) (XMonad.Layout.MultiToggle.Toggle REFLECTX))
    , ("M-S-r"                  , addName "Force Reflect (even on BSP)" $ sendMessage (XMonad.Layout.MultiToggle.Toggle REFLECTX))


    -- If following is run on a floating window, the sequence first tiles it.
    -- Not perfect, but works.
    , ("M-f"                , addName "Fullscreen"                      $ sequence_ [ (withFocused $ windows . W.sink)
                                                                        , (sendMessage $ XMonad.Layout.MultiToggle.Toggle FULL) ])

    -- Fake fullscreen fullscreens into the window rect. The expand/shrink
    -- is a hack to make the full screen paint into the rect properly.
    -- The tryMsgR handles the BSP vs standard resizing functions.
    , ("M-S-f"                  , addName "Fake fullscreen"             $ sequence_ [ (P.sendKey P.noModMask xK_F11)
                                                                                    , (tryMsgR (ExpandTowards L) (Shrink))
                                                                                    , (tryMsgR (ExpandTowards R) (Expand)) ])
    {-, ("C-S-h"                  , addName "Ctrl-h passthrough"          $ P.sendKey controlMask xK_h)-}
    {-, ("C-S-j"                  , addName "Ctrl-j passthrough"          $ P.sendKey controlMask xK_j)-}
    {-, ("C-S-k"                  , addName "Ctrl-k passthrough"          $ P.sendKey controlMask xK_k)-}
    {-, ("C-S-l"                  , addName "Ctrl-l passthrough"          $ P.sendKey controlMask xK_l)-}
    ] ^++^

    -----------------------------------------------------------------------
    -- Reference
    -----------------------------------------------------------------------
    -- recent windows not working
    -- , ("M4-<Tab>",              , addName "Cycle recent windows"        $ (cycleRecentWindows [xK_Super_L] xK_Tab xK_Tab))
    -- either not using these much or (in case of two tab items below), they conflict with other bindings
    -- so I'm just turning off this whole section for now. retaining for refernce after a couple months
    -- of working with my bindings to see if I want them back. TODO REVIEW
    --, ("M-s m"                  , addName "Swap master"                 $ windows W.shiftMaster)
    --, ("M-s p"                  , addName "Swap next"                   $ windows W.swapUp)
    --, ("M-s n"                  , addName "Swap prev"                   $ windows W.swapDown)
    --, ("M-<Tab>"                , addName "Cycle up"                    $ windows W.swapUp)
    --, ("M-S-<Tab>"              , addName "Cycle down"                  $ windows W.swapDown)

    -- sublayout specific (unused)
    -- , ("M4-C-S-m"               , addName "onGroup focusMaster"         $ onGroup focusMaster')
    -- , ("M4-C-S-]"               , addName "toSubl IncMasterN 1"         $ toSubl $ IncMasterN 1)
    -- , ("M4-C-S-["               , addName "toSubl IncMasterN -1"        $ toSubl $ IncMasterN (-1))
    -- , ("M4-C-S-<Return>"        , addName "onGroup swapMaster"          $ onGroup swapMaster')


    -----------------------------------------------------------------------
    -- Resizing
    -----------------------------------------------------------------------

    subKeys "Resize"

    [

    -- following is a hacky hack hack
    --
    -- I want to be able to use the same resize bindings on both BinarySpacePartition and other
    -- less sophisticated layouts. BSP handles resizing in four directions (amazing!) but other
    -- layouts have less refined tastes and we're lucky if they just resize the master on a single
    -- axis.
    --
    -- To this end, I am using X.A.MessageFeedback to test for success on using the BSP resizing
    -- and, if it fails, defaulting to the standard (or the X.L.ResizableTile Mirror variants)
    -- Expand and Shrink commands.
    --
    -- The "sequence_" wrapper is needed because for some reason the windows weren't resizing till
    -- I moved to a different window or refreshed, so I added that here. Shrug.

    -- mnemonic: less than / greater than
    --, ("M4-<L>"       , addName "Expand (L on BSP)"     $ sequence_ [(tryMessage_ (ExpandTowards L) (Expand)), refresh])

      ("M-["                    , addName "Expand (L on BSP)"           $ tryMsgR (ExpandTowards L) (Shrink))
    , ("M-]"                    , addName "Expand (R on BSP)"           $ tryMsgR (ExpandTowards R) (Expand))
    , ("M-S-["                  , addName "Expand (U on BSP)"           $ tryMsgR (ExpandTowards U) (MirrorShrink))
    , ("M-S-]"                  , addName "Expand (D on BSP)"           $ tryMsgR (ExpandTowards D) (MirrorExpand))

    , ("M-C-["                  , addName "Shrink (L on BSP)"           $ tryMsgR (ShrinkFrom R) (Shrink))
    , ("M-C-]"                  , addName "Shrink (R on BSP)"           $ tryMsgR (ShrinkFrom L) (Expand))
    , ("M-C-S-["                , addName "Shrink (U on BSP)"           $ tryMsgR (ShrinkFrom D) (MirrorShrink))
    , ("M-C-S-]"                , addName "Shrink (D on BSP)"           $ tryMsgR (ShrinkFrom U) (MirrorExpand))

  --, ("M-r"                    , addName "Mirror (BSP rotate)"         $ tryMsgR (Rotate) (XMonad.Layout.MultiToggle.Toggle MIRROR))
  --, ("M-S-C-m"                , addName "Mirror (always)"             $ sendMessage $ XMonad.Layout.MultiToggle.Toggle MIRROR)
  --, ("M4-r"                   , addName "BSP Rotate"                  $ sendMessage Rotate)

-- TODO: the following are potentially useful but I won't know till I work with BSP further
--    , ("M4-s"                   , addName "BSP Swap"                    $ sendMessage XMonad.Layout.BinarySpacePartition.Swap)
--    , ("M4-p"                   , addName "BSP Focus Parent"            $ sendMessage FocusParent)
--    , ("M4-n"                   , addName "BSP Select Node"             $ sendMessage SelectNode)
    --, ("M4-m"                   , addName "BSP Move Node"               $ sendMessage MoveNode)

    -- sublayout specific (unused)
    --  ("M4-C-S-."               , addName "toSubl Shrink"               $ toSubl Shrink)
    --, ("M4-C-S-,"               , addName "toSubl Expand"               $ toSubl Expand)
    ]
    where
      toggleCopyToAll = wsContainingCopies >>= \ws -> case ws of
              [] -> windows copyToAll
              _ -> killAllOtherCopies


base03  = "#002b36"
base02  = "#073642"
base01  = "#586e75"
base00  = "#657b83"
base0   = "#839496"
base1   = "#93a1a1"
base2   = "#eee8d5"
base3   = "#fdf6e3"
yellow  = "#b58900"
orange  = "#cb4b16"
red     = "#dc322f"
magenta = "#d33682"
violet  = "#6c71c4"
blue    = "#268bd2"
cyan    = "#2aa198"
green       = "#859900"

-- sizes
gap         = 2
topbar      = 10
border      = 1
prompt      = 20
status      = 20

myNormalBorderColor     = "#000000"
myFocusedBorderColor    = active

active      = blue
activeWarn  = red
inactive    = base02
focusColor  = blue
unfocusColor = base02

myFont      = "-*-terminus-medium-*-*-*-*-160-*-*-*-*-*-*"
myBigFont   = "-*-terminus-medium-*-*-*-*-240-*-*-*-*-*-*"
myWideFont  = "xft:Eurostar Black Extended:"
            ++ "style=Regular:pixelsize=180:hinting=true"
-- this is a "fake title" used as a highlight bar in lieu of full borders
-- (I find this a cleaner and less visually intrusive solution)
topBarTheme = def
    { fontName              = myFont
    , inactiveBorderColor   = base03
    , inactiveColor         = base03
    , inactiveTextColor     = base03
    , activeBorderColor     = active
    , activeColor           = active
    , activeTextColor       = active
    , urgentBorderColor     = red
    , urgentTextColor       = yellow
    , decoHeight            = topbar
    }

myTabTheme = def
    { fontName              = myBigFont
    , activeColor           = active
    , inactiveColor         = base02
    , activeBorderColor     = active
    , inactiveBorderColor   = base02
    , activeTextColor       = base03
    , inactiveTextColor     = base00
    }

myPromptTheme = def
    { font                  = myFont
    , bgColor               = base03
    , fgColor               = active
    , fgHLight              = base03
    , bgHLight              = active
    , borderColor           = base03
    , promptBorderWidth     = 0
    , height                = prompt
    , position              = Top
    }

warmPromptTheme = myPromptTheme
    { bgColor               = yellow
    , fgColor               = base03
    , position              = Top
    }

hotPromptTheme = myPromptTheme
    { bgColor               = red
    , fgColor               = base3
    , position              = Top
    }

myShowWNameTheme = def
    { swn_font              = myWideFont
    , swn_fade              = 0.5
    , swn_bgcolor           = "#000000"
    , swn_color             = "#FFFFFF"
    }

------------------------------------------------------------------------}}}
-- Workspaces                                                           {{{
---------------------------------------------------------------------------

wsGen   = "gen"
wsWork   = "work"
ws3     = "3"
ws4     = "4"
ws5     = "5"
wsTest  = "test"
wsIM    = "im"
ws8   = "8"
ws9   = "9"
wsFloat = "float"
wsMusic = "music"
wsRun = "run"

-- myWorkspaces = map show [1..9]
myWorkspaces = [wsGen, wsWork, ws3, ws4, ws5, wsTest, wsIM, ws8, ws9, wsFloat]

projects :: [Project]
projects =

    [ Project   { projectName       = wsGen
                , projectDirectory  = "~/"
                , projectStartHook  = Nothing
                }

    , Project   { projectName       = wsWork
                , projectDirectory  = "~/dev/circuithub"
                , projectStartHook  = Just $ do spawnOn wsWork "termite"
                                                spawnOn wsWork "termite"
                                                spawnOn wsWork "termite"
                                                spawnOn wsWork "firefox"
                }

    , Project   { projectName       = ws3
                , projectDirectory  = "~/dev/circuithub"
                , projectStartHook  =  Nothing
                }
    , Project   { projectName       = ws4
                , projectDirectory  = "~/dev/circuithub"
                , projectStartHook  = Nothing
                }
    , Project   { projectName       = ws5
                , projectDirectory  = "~/dev/circuithub"
                , projectStartHook  = Nothing
                }

    , Project   { projectName       = wsTest
                , projectDirectory  = "~/"
                , projectStartHook  = Nothing
                }

    , Project   { projectName       = wsIM
                , projectDirectory  = "~/"
                , projectStartHook  = Nothing
                }

    , Project   { projectName       = ws8
                , projectDirectory  = "~/"
                , projectStartHook  = Nothing
                }

    , Project   { projectName       = ws9
                , projectDirectory  = "~/"
                , projectStartHook  = Nothing
                }

    , Project   { projectName       = wsFloat
                , projectDirectory  = "~/"
                , projectStartHook  = Nothing
                }
    , Project   { projectName       = wsMusic
                , projectDirectory  = "~/"
                , projectStartHook  = Nothing
                }
    , Project   { projectName       = wsRun
                , projectDirectory  = "~/dev/circuithub"
                , projectStartHook  = Just $ do spawnOn wsRun "termite"
                                                spawnOn wsRun "termite"
                                                spawnOn wsRun "termite"
                }
    ]

------------------------------------------------------------------------}}}
-- Applications                                                         {{{
---------------------------------------------------------------------------

-- | Uses supplied function to decide which action to run depending on current workspace name.

myTerminal          = "termite"
myLauncher          = "dmenu_run"
