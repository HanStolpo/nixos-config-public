import System.Taffybar
import System.Taffybar.SimpleConfig

--import System.Taffybar.Systray
--import System.Taffybar.TaffyPager
import System.Taffybar.Widget.SimpleClock
import System.Taffybar.Widget.FreedesktopNotifications
--import System.Taffybar.Weather
--import System.Taffybar.MPRIS
import System.Taffybar.Widget.SNITray
import System.Taffybar.Widget.Battery
import System.Taffybar.Widget.Text.CPUMonitor

import System.Taffybar.Widget.Generic.PollingBar
import System.Taffybar.Widget.Generic.PollingGraph
import System.Taffybar.Widget.Generic.PollingLabel

import System.Taffybar.Information.Memory
import System.Taffybar.Information.CPU2

import Text.Printf (printf)

import System.Taffybar.Widget.Workspaces
import System.Taffybar.Widget.Layout
import System.Taffybar.Widget.Battery

memCallback = do
  mi <- parseMeminfo
  return (memoryUsedRatio mi)

cpuCallback = do
  [systemTime, userTime] <- getCPULoad "cpu"
  return (userTime + systemTime)

cpuCallbackText = do
  r <- cpuCallback
  return (printf "<span>CPU %02.0f</span>" (r * 100.0) :: String)

main = do
  let greenWhiteRedBar =
        defaultBarConfig
          (\x -> case x of
              x | x < 0.25 -> (0, 0.6, 0)
              x | x < 0.75 -> (0.6, 0.6, 0.6)
              _  -> (0.6, 0, 0)
                                    )
  let clock = textClockNew Nothing "<span fgcolor='orange'>%a %b %_d %H:%M</span>" 1
      workspaces = workspacesNew defaultWorkspacesConfig
      note = notifyAreaNew defaultNotificationConfig
      mem = pollingBarNew greenWhiteRedBar 1 memCallback
      cpu = pollingBarNew greenWhiteRedBar 0.5 cpuCallback
      tray = sniTrayThatStartsWatcherEvenThoughThisIsABadWayToDoIt -- sniTrayNew
      battery = textBatteryNew "bat:$percentage$% $time$"
      layout = layoutNew defaultLayoutConfig
      simpleConfig =
        defaultSimpleTaffyConfig
          { startWidgets = [ workspaces, note, layout  ]
          , endWidgets = [ tray, clock, mem, cpu, battery]
          }
  simpleTaffybar simpleConfig
