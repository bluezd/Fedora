import XMonad
import XMonad.Config.Azerty  
import XMonad.Hooks.DynamicLog  
import XMonad.Hooks.ManageDocks  
import XMonad.Util.Run(spawnPipe)  
import XMonad.Util.EZConfig  
import Graphics.X11.ExtraTypes.XF86  
import XMonad.Layout.Spacing  
import XMonad.Layout.NoBorders(smartBorders)  
import XMonad.Layout.PerWorkspace  
import XMonad.Layout.IM  
import XMonad.Layout.Grid  
import Data.Ratio ((%))  
import XMonad.Actions.CycleWS  
import qualified XMonad.StackSet as W  
import System.IO  

myWorkspaces = ["1:Web","2:term","3:irc","4:mail","5:work","6:ssh", "7:chrome", "8:pidgin"]

myLayout = onWorkspace "8:Pidgin" pidginLayout $ onWorkspaces ["2:term", "7:chrome"] nobordersLayout $ tiled1 ||| Mirror tiled1 ||| nobordersLayout  
 where  
  tiled1 = spacing 5 $ Tall nmaster1 delta ratio  
  --tiled2 = spacing 5 $ Tall nmaster2 delta ratio  
  nmaster1 = 1   
  nmaster2 = 2   
  ratio = 2/3  
  delta = 3/100  
  nobordersLayout = smartBorders $ Full  
  gridLayout = spacing 8 $ Grid           
  pidginLayout = withIM (18/100) (Role "buddy_list") gridLayout  
myManageHook = composeAll           
     [ className =? "File Operation Progress"   --> doFloat  
     , resource =? "desktop_window" --> doIgnore  
     , className =? "xfce4-notifyd" --> doIgnore  
     , className =? "Firefox" --> doShift "1:Web"  
     , className =? "Pidgin" --> doShift "8:Pidgin"  
     ]  

main = do
    xmproc <- spawnPipe "/usr/bin/xmobar /home/bluezd/.xmonad/xmobarrc"
    xmonad $ defaultConfig
        { manageHook = manageDocks <+> manageHook defaultConfig
        -- , layoutHook = avoidStruts  $  layoutHook defaultConfig
        -- , logHook = dynamicLogWithPP xmobarPP
        --                { ppOutput = hPutStrLn xmproc
        --                , ppTitle = xmobarColor "green" "" . shorten 50
        --                }
    
	, layoutHook = avoidStruts $ myLayout  
        , logHook = dynamicLogWithPP xmobarPP  
            { ppOutput = hPutStrLn xmproc  
               , ppTitle = xmobarColor "#2CE3FF" "" . shorten 50  
               , ppLayout = const "" -- to disable the layout info on xmobar  
            }   
        , modMask = mod4Mask     -- Rebind Mod to the Windows key
	, workspaces = myWorkspaces
	, borderWidth = 2
	, normalBorderColor = "#60A1AD"
	, focusedBorderColor = "#68e862"
        } `additionalKeys`
        [ ((mod4Mask .|. shiftMask, xK_z), spawn "xscreensaver-command -lock")
	, ((mod4Mask, xK_Return), spawn "urxvt256c") -- spawn terminator terminal
	, ((mod4Mask, xK_f), spawn "firefox")
	, ((mod4Mask, xK_p), spawn "pidgin")
	, ((mod4Mask, xK_F2), spawn "gmrun")
        , ((controlMask, xK_Print), spawn "sleep 0.2; scrot -s")
        , ((0, xK_Print), spawn "scrot")
        ]
