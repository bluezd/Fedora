-- Standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")
require("vicious")
require("myplacesmenu")

-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
-- beautiful.init(awful.util.getdir("config") .. "/theme.lua")
-- beautiful.init("/usr/share/awesome/themes/default/theme.lua")
beautiful.init("/home/zhudong/.config/awesome/themes/wombat/theme.lua")
--beautiful.init("/usr/share/awesome/themes/sky/theme.lua")
--beautiful.init("/home/zhudong/.config/awesome/zenburn.lua")

-- Private naughty config
naughty.config.default_preset.font             = "sans 13.5"
naughty.config.default_preset.position         = "bottom_right"
naughty.config.default_preset.fg               = beautiful.fg_focus
naughty.config.default_preset.bg               = beautiful.bg_focus
naughty.config.default_preset.border_color     = beautiful.border_focus

-- This is used later as the default terminal and editor to run.
--terminal = "xterm"
terminal = "urxvt"
editor = "vim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"


--{ "files", myplacesmenu.myplacesmenu()},
-- Applications to be moved to a pre-defined tag by class or instance.
-- Use the screen and tags indices.

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.max,
    awful.layout.suit.floating
}

--{{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag({ 1, 2, 3, 4, 5, 6, 7, 8, 9 }, s, layouts[5])
end

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "files", myplacesmenu.myplacesmenu()},
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awful.util.getdir("config") .. "/rc.lua" },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon),
                                     menu = mymainmenu })
-- }}}


tags[1][1].name = "Web"
tags[1][2].name = "Term"
tags[1][3].name = "IRC"
tags[1][4].name = "Mail"
tags[1][5].name = "work"
tags[1][6].name = "Other"
-- }}}


apptags =
{
    ["pidgin"] = { screen = 1, tag = 7 },
    ["firefox"] = { screen = 1, tag = 0 },
    ["stardict"] = { screen = 1, tag = 8 },
}

-- {{{ Wibox

separator = widget({ type = "imagebox" })
separator.image = image(beautiful.widget_sep)

dnicon = widget({ type = "imagebox" })
upicon = widget({ type = "imagebox" })
dnicon.image = image(beautiful.widget_net)
upicon.image = image(beautiful.widget_netup)

cpuicon = widget({ type = "imagebox" })
cpuicon.image = image(beautiful.widget_cpu)

dateicon = widget({ type = "imagebox" })
dateicon.image = image(beautiful.widget_date)

memicon = widget({ type = "imagebox" })
memicon.image = image(beautiful.widget_mem)

mpdicon = widget({ type = "imagebox" })
mpdicon.image = image(beautiful.widget_mpd)

volicon = widget({ type = "imagebox" })
volicon.image = image(beautiful.widget_vol)

baticon = widget({ type = "imagebox" })
baticon.image = image(beautiful.widget_bat)
weathericon = widget({ type = "imagebox" })
weathericon.image = image(beautiful.widget_cloud)
mailicon = widget({ type = "imagebox" })
mailicon.image = image(beautiful.widget_mail)



--  CPU usage widget
-- Initialize widget
cpuwidget = widget({ type = "textbox" })
-- Register widget
vicious.register(cpuwidget, vicious.widgets.cpu, "$1%")


-- {{{2 Volume Control
volume_cardid = 0
volume_channel = "Master"
function volume (mode, widget)
  if mode == "update" then
    local fd = io.popen("amixer -c " .. volume_cardid .. " -- sget " .. volume_channel)
    local status = fd:read("*all")
    fd:close()

    local volume = string.match(status, "(%d?%d?%d)%%")
    volume = string.format("% 3d", volume)

    status = string.match(status, "%[(o[^%]]*)%]")

    if string.find(status, "on", 1, true) then
      volume = volume .. "%"
    else
--      volume = '' .. volume .. "<span color='red'>M</span>"
      volume = volume .. "<span color='red'>M</span>"
    end
    widget.text = volume
  elseif mode == "up" then
    io.popen("amixer -q -c " .. volume_cardid .. " sset " .. volume_channel .. " 5%+"):read("*all")
    volume("update", widget)
  elseif mode == "down" then
    io.popen("amixer -q -c " .. volume_cardid .. " sset " .. volume_channel .. " 5%-"):read("*all")
    volume("update", widget)
  else
    io.popen("amixer -c " .. volume_cardid .. " sset " .. volume_channel .. " toggle"):read("*all")
    volume("update", widget)
  end
end
volume_clock = timer({ timeout = 10 })
volume_clock:add_signal("timeout", function () volume("update", tb_volume) end)
volume_clock:start()

tb_volume = widget({ type = "textbox", name = "tb_volume", align = "right" })
tb_volume.width = 35
tb_volume:buttons(awful.util.table.join(
  awful.button({ }, 4, function () volume("up", tb_volume) end),
  awful.button({ }, 5, function () volume("down", tb_volume) end),
  awful.button({ }, 1, function () volume("mute", tb_volume) end)
))
volume("update", tb_volume)

-- Initialize widget
memwidget = widget({ type = "textbox" })
-- -- Register widget
--vicious.register(memwidget, vicious.widgets.mem, "$1% ($2MB/$3MB)", 13)
vicious.register(memwidget, vicious.widgets.mem, "$1%", 1)




--  Network usage widget
-- Initialize widget
netwidget = widget({ type = "textbox" })
-- Register widget
vicious.register(netwidget, vicious.widgets.net, '<span color="#CC9393">${eth0 down_kb}</span> <span color="#7F9F7F">${eth0 up_kb}</span>', 3)


-- {{{ Date and time
-- Initialize widget
datewidget = widget({ type = "textbox" })
-- Register widget
vicious.register(datewidget, vicious.widgets.date, "%R", 61)

-- MPD
-- Initialize widget
mpdwidget = widget({ type = "textbox" })
-- Register widget
vicious.register(mpdwidget, vicious.widgets.mpd,
    function (widget, args)
        if args["{state}"] == "Stop" then 
            return " - "
        else 
            return args["{Artist}"]..' - '.. args["{Title}"]
        end
    end, 10)

-- {{{2 Volume Control
volume_cardid = 0
volume_channel = "Master"
function volume (mode, widget)          
  if mode == "update" then              
    local fd = io.popen("amixer -c " .. volume_cardid .. " -- sget " .. volume_channel)
    local status = fd:read("*all")
    fd:close()
   
    local volume = string.match(status, "(%d?%d?%d)%%")
    volume = string.format("% 3d", volume)
   
    status = string.match(status, "%[(o[^%]]*)%]")
   
    if string.find(status, "on", 1, true) then
      volume = volume .. "%"
    else
--      volume = '' .. volume .. "<span color='red'>M</span>"
      volume = volume .. "<span color='red'>M</span>"
    end           
    widget.text = volume        
  elseif mode == "up" then      
    io.popen("amixer -q -c " .. volume_cardid .. " sset " .. volume_channel .. " 5%+"):read("*all")
    volume("update", widget)    
  elseif mode == "down" then    
    io.popen("amixer -q -c " .. volume_cardid .. " sset " .. volume_channel .. " 5%-"):read("*all")
    volume("update", widget) 
  else                       
    io.popen("amixer -c " .. volume_cardid .. " sset " .. volume_channel .. " toggle"):read("*all")
    volume("update", widget)
  end
end
volume_clock = timer({ timeout = 10 })
volume_clock:add_signal("timeout", function () volume("update", tb_volume) end)
volume_clock:start()
   
tb_volume = widget({ type = "textbox", name = "tb_volume", align = "right" })
tb_volume.width = 35
tb_volume:buttons(awful.util.table.join(
  awful.button({ }, 4, function () volume("up", tb_volume) end),
  awful.button({ }, 5, function () volume("down", tb_volume) end),
  awful.button({ }, 1, function () volume("mute", tb_volume) end)
))
volume("update", tb_volume)

--Battery widget
batwidget = widget({ type = 'textbox' })
vicious.register(batwidget, vicious.widgets.bat, "$1 $2", 10, "BAT0")

-- mail
mailwidget = widget({ type = "textbox" })
vicious.register(mailwidget, vicious.widgets.mdir, 'Mail $1', 5, { '/home/bluezd/Documents/Mails/Zimbra/zhudong/' })


-- Create a textclock widget
mytextclock = awful.widget.textclock({ align = "right" }, " %a %b %d, %H:%M ", 1)

-- Initialize widget
--mystatusbar = awful.wibox({ position = "top", screen = 1, ontop = true, width = 1, height = 20 })

-- Weather
weatherwidget = widget({ type = "textbox" })
weather_t = awful.tooltip({ objects = { weatherwidget },})
vicious.register(weatherwidget, vicious.widgets.weather,
        function (widget, args)
            weather_t:set_text("City: " .. args["{city}"] .."\nWind: " .. args["{windmph}"] .. " mp/h " .. args["{wind}"] .. "\nSky: " .. args["{sky}"] .. "\nHumidity: " .. args["{humid}"] .. "%") 
            return args["{tempc}"] .. "°C"
        end, 180, "ZBAA")

-- {{{ Widgets configuration

-- Create a systray
-- mysystray = widget({ type = "systray" })

-- Private decoration
myicon = widget({ type = "imagebox" })
myicon.image = image(beautiful.awesome_icon)
myspace = widget({ type = "textbox" })
myspace.text = "  "

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, awful.tag.viewnext),
                    awful.button({ }, 5, awful.tag.viewprev)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(function(c)
                                              return awful.widget.tasklist.label.currenttags(c, s)
                                          end, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "bottom", screen = s })
    -- Add widgets to the wibox - order matters
    mywibox[s].widgets = {
        {
--            myspace,
--            mylayoutbox[s],
            mylauncher,
--          myspace,
            mytaglist[s],
            mypromptbox[s],
            layout = awful.widget.layout.horizontal.leftright
        },
--      mytextclock,
        mylayoutbox[s],
        myspace,
        s == 1 and mysystray or nil,
        myspace,mytextclock,dateicon,
--        separator,volbar,volicon,
--        datewidget,dateicon,
--          separator,weather,weathericon,
          separator,weatherwidget,weathericon,
--          separator,volwidget,volicon,
          separator,batwidget,baticon,
          separator,mailwidget,mailicon,
          separator,tb_volume,volicon,
          separator, upicon, netwidget, dnicon,
          separator,memwidget,memicon,
--        cputempwidget,
          separator,cpuwidget,cpuicon,
--        separator,cgraph,cpuwidget,cpuicon,
        separator,mpdwidget,mpdicon,
--        s == 1 and mysystray or nil,
        mytasklist[s],
        layout = awful.widget.layout.horizontal.rightleft
    }  

end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    -- Private global keys
    awful.key({ modkey, }, "a", function () awful.util.spawn("xterm -e alsamixer") end),
    awful.key({ modkey, }, "b", function () mywibox[mouse.screen].visible = not mywibox[mouse.screen].visible end),
    awful.key({ modkey, }, "i", function () awful.util.spawn("firefox") end),
    awful.key({ modkey, }, "m", function () awful.util.spawn("amixer -q sset Master toggle") end),
    awful.key({ modkey, }, "p", function () awful.util.spawn("pidgin") end),
    awful.key({ modkey, }, "f", function () awful.util.spawn("nautilus") end),
    awful.key({ modkey, }, "s", function () awful.util.spawn("xlock -mode blank -dpmsoff 5 -font -misc-fixed-*-*-*-*-20-*-*-*-*-*-*") end),
    awful.key({ modkey, }, "t", function () awful.util.spawn("mpc toggle") end),
    awful.key({ modkey, }, "l", function () awful.util.spawn("stardict") end),
    awful.key({ modkey, }, "v", function () awful.util.spawn("virtualbox") end),
--    awful.key({ modkey, }, "x", function () awful.util.spawn("xterm") end),
    awful.key({ modkey, }, "x", function () awful.util.spawn("urxvt") end),
    awful.key({ modkey, }, "Up", function () awful.util.spawn("amixer -q sset Master 10%+ unmute") end),
    awful.key({ modkey, }, "Down", function () awful.util.spawn("amixer -q sset Master 10%- unmute") end),
    awful.key({ modkey, }, "F2", function () awful.util.spawn("gmrun") end),
    awful.key({ "Mod1" }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),
    awful.key({ "Mod1" }, "Print",
        function ()
	    awful.util.spawn("scrot -u -e 'mv $f ~/Pictures/Shot/'")
	    os.execute("sleep 0.5")
	    naughty.notify({ title="Screenshot", text="The focused window captured" })
        end),
    awful.key({}, "Print",
        function ()
	    awful.util.spawn("scrot -e 'mv $f ~/Pictures/Shot/'")
	    os.execute("sleep 0.5")
	    naughty.notify({ title="Screenshot", text="Full screen captured" })
        end),
--    awful.key({}, "XF86AudioPlay", function () awful.util.spawn("mpc toggle") end),
--    awful.key({}, "XF86AudioStop", function () awful.util.spawn("mpc stop") end),
--    awful.key({}, "XF86AudioPrev", function () awful.util.spawn("mpc prev") end),
--    awful.key({}, "XF86AudioNext", function () awful.util.spawn("mpc next") end),
    
    awful.key({modkey, }, "z", function () awful.util.spawn("mpc stop") end),
--    awful.key({modkey, }, "s", function () awful.util.spawn("mpc play") end),
    awful.key({modkey, }, "j", function () awful.util.spawn("mpc prev") end),
    awful.key({modkey, }, "n", function () awful.util.spawn("mpc next") end),
    awful.key({}, "XF86AudioMute", function () awful.util.spawn("amixer -q sset Master toggle") end),
    awful.key({}, "XF86AudioLowerVolume", function () awful.util.spawn("amixer -q sset Master 10%- unmute") end),
    awful.key({}, "XF86AudioRaiseVolume", function () awful.util.spawn("amixer -q sset Master 10%+ unmute") end)

)

clientkeys = awful.util.table.join(
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    awful.key({ modkey,           }, "n",      function (c) c.minimized = not c.minimized    end),

    -- Private client keys
    awful.key({ "Mod1" }, "F3",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end),
    awful.key({ "Mod1" }, "F4", function (c) c:kill() end),
    awful.key({ modkey, "Control" }, "Up",    function () awful.client.moveresize(  0, -20,   0,   0) end),
    awful.key({ modkey, "Control" }, "Down",  function () awful.client.moveresize(  0,  20,   0,   0) end),
    awful.key({ modkey, "Control" }, "Left",  function () awful.client.moveresize(-20,   0,   0,   0) end),
    awful.key({ modkey, "Control" }, "Right", function () awful.client.moveresize( 20,   0,   0,   0) end),
    awful.key({ modkey, "Control" }, "Prior", function () awful.client.moveresize(-20, -20,  40,  40) end),
    awful.key({ modkey, "Control" }, "Next",  function () awful.client.moveresize( 20,  20, -40, -40) end)

)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = true,
                     keys = clientkeys,
                     buttons = clientbuttons } },

    -- Private rules
    { rule = { },
      properties = { size_hints_honor = false } },
    { rule = { class = "Gimp" },
      properties = { floating = true, tag = tags[1][7] } },
    { rule = { class = "Gmrun" },
      properties = { floating = true } },
    { rule = { class = "firefox" },
      properties = { tag = tags[1][1] } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "Pidgin" },
      properties = { floating = true, tag = tags[1][8] } },
    { rule = { class = "VirtualBox" },
      properties = { tag = tags[1][9] } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.add_signal("manage", function (c, startup)
    -- Add a titlebar
    -- awful.titlebar.add(c, { modkey = modkey })

    -- Enable sloppy focus
    c:add_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
end)

-- client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
-- client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
 client.add_signal("focus", function(c) c.border_color = beautiful.border_focus c.opacity = 1 end)
 client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal c.opacity = 0.7 end)
-- }}}
