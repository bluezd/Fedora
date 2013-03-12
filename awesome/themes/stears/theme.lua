-- "Sweet Tears" theme for Awesome WM, by bluezd.  
-- Icons are taken from the "Dust" theme by tdy @ https://github.com/tdy/dotfiles
-- Wallpaper can be found @ http://wallbase.cc/wallpaper/689174
-- REMEMBER: Always change default paths as necessary.

theme = {}

-- theme.wallpaper_cmd = { "nitrogen --restore" }
--}}}

theme.font          = "anorexia 8"

theme.bg_normal     = "#050608"
theme.bg_focus      = "#050608"
theme.bg_urgent     = "#A9D7F2"
theme.bg_minimize   = "#050608"

theme.fg_normal     = "#B1917A"
theme.fg_focus      = "#A9D7F2"
theme.fg_urgent     = "#ffffff"
theme.fg_minimize   = "#B1917A"

theme.border_width  = "1"
theme.border_normal = "#050608"
theme.border_focus  = "#A8D8EF"
theme.border_marked = "#FBDE8E"

theme.bg_widget        = "#333333"
theme.fg_widget        = "#908884"
theme.fg_center_widget = "#636363"
theme.fg_end_widget    = "#ffffff"
theme.fg_off_widget    = "#22211f"

-- Tag client markers
theme.taglist_squares_sel = "/home/bluezd/.config/awesome/themes/stears/taglist14/squaref.png"
theme.taglist_squares_unsel = "/home/bluezd/.config/awesome/themes/stears/taglist14/square.png"

theme.tasklist_floating_icon = "/usr/share/awesome/themes/default/tasklist/floatingw.png"

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = "/usr/share/awesome/themes/default/submenu.png"
theme.menu_height = "15"
theme.menu_width  = "100"

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Define the image to load
theme.titlebar_close_button_normal = "/usr/share/awesome/themes/default/titlebar/close_normal.png"
theme.titlebar_close_button_focus  = "/usr/share/awesome/themes/default/titlebar/close_focus.png"

theme.titlebar_ontop_button_normal_inactive = "/usr/share/awesome/themes/default/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive  = "/usr/share/awesome/themes/default/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = "/usr/share/awesome/themes/default/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active  = "/usr/share/awesome/themes/default/titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = "/usr/share/awesome/themes/default/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive  = "/usr/share/awesome/themes/default/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = "/usr/share/awesome/themes/default/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active  = "/usr/share/awesome/themes/default/titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = "/usr/share/awesome/themes/default/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive  = "/usr/share/awesome/themes/default/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active = "/usr/share/awesome/themes/default/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active  = "/usr/share/awesome/themes/default/titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = "/usr/share/awesome/themes/default/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = "/usr/share/awesome/themes/default/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active = "/usr/share/awesome/themes/default/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active  = "/usr/share/awesome/themes/default/titlebar/maximized_focus_active.png"

theme.layout_fairh      = "/home/bluezd/.config/awesome/themes/stears/layouts14/fairhw.png"
theme.layout_fairv      = "/home/bluezd/.config/awesome/themes/stears/layouts14/fairvw.png"
theme.layout_floating   = "/home/bluezd/.config/awesome/themes/stears/layouts14/floatingw.png"
theme.layout_magnifier  = "/home/bluezd/.config/awesome/themes/stears/layouts14/magnifierw.png"
theme.layout_max        = "/home/bluezd/.config/awesome/themes/stears/layouts14/maxw.png"
theme.layout_fullscreen = "/home/bluezd/.config/awesome/themes/stears/layouts14/fullscreenw.png"
theme.layout_tilebottom = "/home/bluezd/.config/awesome/themes/stears/layouts14/tilebottomw.png"
theme.layout_tileleft   = "/home/bluezd/.config/awesome/themes/stears/layouts14/tileleftw.png"
theme.layout_tile       = "/home/bluezd/.config/awesome/themes/stears/layouts14/tilew.png"
theme.layout_tiletop    = "/home/bluezd/.config/awesome/themes/stears/layouts14/tiletopw.png"
theme.layout_spiral     = "/home/bluezd/.config/awesome/themes/stears/layouts14/spiralw.png"
theme.layout_dwindle    = "/home/bluezd/.config/awesome/themes/stearsr/layouts14/dwindlew.png"

theme.awesome_icon = "/home/bluezd/.config/awesome/themes/stears/awesome14-dust.png"

theme.widget_disk     = "/home/bluezd/.config/awesome/themes/stears/icons/stears/disk.png"
theme.widget_ac       = "/home/bluezd/.config/awesome/themes/stears/icons/stears/ac.png"
theme.widget_acblink  = "/home/bluezd/.config/awesome/themes/stears/icons/stears/acblink.png"
theme.widget_blank    = "/home/bluezd/.config/awesome/themes/stears/icons/stears/blank.png"
theme.widget_batfull  = "/home/bluezd/.config/awesome/themes/stears/icons/stears/batfull.png"
theme.widget_batmed   = "/home/bluezd/.config/awesome/themes/stears/icons/stears/batmed.png"
theme.widget_batlow   = "/home/bluezd/.config/awesome/themes/stears/icons/stears/batlow.png"
theme.widget_batempty = "/home/bluezd/.config/awesome/themes/stears/icons/stears/batempty.png"
theme.widget_vol      = "/home/bluezd/.config/awesome/themes/stears/icons/stears/vol.png"
theme.widget_mute     = "/home/bluezd/.config/awesome/themes/stears/icons/stears/mute.png"
theme.widget_pac      = "/home/bluezd/.config/awesome/themes/stears/icons/stears/pac.png"
theme.widget_pacnew   = "/home/bluezd/.config/awesome/themes/stears/icons/stears/pacnew.png"
theme.widget_mail     = "/home/bluezd/.config/awesome/themes/stears/icons/stears/mail.png"
theme.widget_mailnew  = "/home/bluezd/.config/awesome/themes/stears/icons/stears/mailnew.png"
theme.widget_temp     = "/home/bluezd/.config/awesome/themes/stears/icons/stears/temp.png"
theme.widget_tempwarm = "/home/bluezd/.config/awesome/themes/stears/icons/stears12/tempwarm.png"
theme.widget_temphot  = "/home/bluezd/.config/awesome/themes/stears/icons/stears/temphot.png"
theme.widget_wifi     = "/home/bluezd/.config/awesome/themes/stears/icons/stears/wifi.png"
theme.widget_nowifi   = "/home/bluezd/.config/awesome/themes/stears/icons/stears/nowifi.png"
theme.widget_mpd      = "/home/bluezd/.config/awesome/themes/stears/icons/stears/note.png"
theme.widget_play     = "/home/bluezd/.config/awesome/themes/stears/icons/stears/play.png"
theme.widget_pause    = "/home/bluezd/.config/awesome/themes/stears/icons/stears/pause.png"
theme.widget_ram      = "/home/bluezd/.config/awesome/themes/stears/icons/stears/ram.png"
theme.widget_cpu      = "/home/bluezd/.config/awesome/themes/stears/icons/stears/cpu.png"

theme.widget_mem      = "/home/bluezd/.config/awesome/themes/stears/icons/stears12/ram.png"
theme.widget_swap     = "/home/bluezd/.config/awesome/themes/stears/icons/stears12/swap.png"
theme.widget_fs       = "/home/bluezd/.config/awesome/themes/stears/icons/stears/fs.png"
theme.widget_fs2      = "/home/bluezd/.config/awesome/themes/stears/icons/stears12/fs_02.png"
theme.widget_up       = "/home/bluezd/.config/awesome/themes/stears/icons/stears12/up.png"
theme.widget_down     = "/home/bluezd/.config/awesome/themes/stears/icons/stears12/down.png"

return theme
-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:encoding=utf-8:textwidth=80
