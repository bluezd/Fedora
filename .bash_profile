# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs

PATH=$PATH:$HOME/bin

export PATH

#run routine
#ibus
export XMODIFIERS="@im=ibus"
export GTK_IM_MODULE="ibus"
export QT_IM_MODULE="ibus"
ibus-daemon -x -r -d &

#mpd
mpd &

#xresources
#xrdb ~/.Xresources
xrdb ~/.Xdefaults

xsetroot -cursor_name left_ptr

# run conky
#pkill conky
#conky -c ~/.conky/weather.conky &
#conky -c ~/.conky/conkyrc &

gnome-power-manager &
#nm-applet &
update-notifier &

#conky -c ~/.conky/conkyrc_red
conky -c ~/.conky/conkyrc_orange
#conky &

exec xcompmgr &
