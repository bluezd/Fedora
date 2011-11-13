# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs

PATH=$PATH:$HOME/bin

export PATH

# Here is bash color codes you can use
black=$'\[\e[1;30m\]'
red=$'\[\e[1;31m\]'
green=$'\[\e[1;32m\]'
yellow=$'\[\e[1;33m\]'
blue=$'\[\e[1;34m\]'
magenta=$'\[\e[1;35m\]'
cyan=$'\[\e[1;36m\]'
white=$'\[\e[1;37m\]'
normal=$'\[\e[m\]'

#PS1="$magenta[$blue\u$white:$green\T$white:$cyan\w$yellow\$git_branch$magenta]$white\$ $normal"

PS1="$red[\[\033[1;32m\]\u\[\033[1;33m\]:\[\033[1;36m\]\t \[\033[1;35m\]\w\[\033[0m\]$red]$normal\$ "

# For ROOT
#PS1="$cyan[\[\033[1;31m\]\u\[\033[1;33m\]:\[\033[1;32m\]Fedora \[\033[1;35m\]\w\[\033[0m\]$cyan]$normal# "

export PS1

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
