import System.Taffybar

import System.Taffybar.Systray
import System.Taffybar.TaffyPager
import System.Taffybar.SimpleClock
import System.Taffybar.FreedesktopNotifications
import System.Taffybar.Weather
import System.Taffybar.MPRIS
import System.Taffybar.Battery
import System.Taffybar.Text.CPUMonitor

import System.Taffybar.Widgets.PollingBar
import System.Taffybar.Widgets.PollingGraph
import System.Taffybar.Widgets.PollingLabel

import System.Information.Memory
import System.Information.CPU2

import Text.Printf (printf)

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
      pager = taffyPagerNew defaultPagerConfig
      note = notifyAreaNew defaultNotificationConfig
      mem = pollingBarNew greenWhiteRedBar 1 memCallback
      cpu = pollingBarNew greenWhiteRedBar 0.5 cpuCallback
      cpuText = textCpuMonitorNew "CPU $total$" 1
      {-cpuText = pollingLabelNew "<span>CPU 00</span>" 1 cpuCallbackText-}
      tray = systrayNew
      battery = textBatteryNew "bat:$percentage$% $time$" 10
  defaultTaffybar defaultTaffybarConfig { startWidgets = [ pager, note ]
                                        , endWidgets = [ tray, clock, mem, cpu, cpuText, battery ]
}
