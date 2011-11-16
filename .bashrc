# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific aliases and functions
alias sd='sudo shutdown -h now'
alias ht='sudo halt -p'
alias rb='sudo reboot'
alias dh='df -h'
alias fd='fdisk -l'

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

if [ $color_prompt=yes ]; then
#PS1='\n\[\e[1;31m\][\w]\[\e[0m\] \[\e[1;35m\][ \[\e[1;36m\]$(/bin/ls -1 | /usr/bin/wc -l | /bin/sed "s: ::g") files \[\e[1;33m\]$(/bin/ls -lah | /bin/grep -m 1 total | /bin/sed "s/total //")b\[\e[0m\] \[\e[1;35m\]]\n`a=$?;if [ $a -ne 0 ]; then echo -ne "\[\e[01;36;41m\]{$a}"; fi`\[\e[01;36m\][\t \u]\[\e[00m\] \[\e[01;34m\]\W`[[ -d .git ]] && echo -ne "\[\e[33;40m\](branch:$(git branch | sed -e "/^ /d" -e "s/* \(.*\)/\1/"))\[\e[01;32m\]\[\e[00m\]"`\[\e[01;34m\] \$ \[\e[00m\]'
        PS1='\[\e[1;31m\][\w]\[\e[0m\] \[\e[1;35m\][ \[\e[1;36m\]$(/bin/ls -1 | /usr/bin/wc -l | /bin/sed "s: ::g") files \[\e[1;33m\]$(/bin/ls -lah | /bin/grep -m 1 total | /bin/sed "s/total //")b\[\e[0m\] \[\e[1;35m\]]\n`a=$?;if [ $a -ne 0 ]; then echo -ne "\[\e[01;36;41m\]{$a}"; fi`\[\e[01;36m\][\t \u]\[\e[00m\] \[\e[01;34m\]\W`[[ -d .git ]] && echo -ne "\[\e[33;40m\](branch:$(git branch | sed -e "/^ /d" -e "s/* \(.*\)/\1/"))\[\e[01;32m\]\[\e[00m\]"`\[\e[01;34m\] \$ \[\e[00m\]'

else
        PS1='\n[\w] [ $(/bin/ls -1 | /usr/bin/wc -l | /bin/sed "s: ::g") files $(/bin/ls -lah | /bin/grep -m 1 total | /bin/sed "s/total //")b ]\n`a=$?;if [ $a -ne 0 ]; then echo -ne "{$a}"; fi`[\t \u] \W`[[ -d .git ]] && echo -ne "(branch:$(git branch | sed -e "/^ /d" -e "s/* \(.*\)/\1/"))"` \$ '
fi
unset color_prompt

export LESS_TERMCAP_mb=$'\E[05;34m'       # begin blinking
export LESS_TERMCAP_md=$'\E[01;36m'       # begin bold
export LESS_TERMCAP_me=$'\E[0m'           # end mode
export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
export LESS_TERMCAP_so=$'\E[44;33m'       # begin standout-mode
export LESS_TERMCAP_ue=$'\E[0m'           # end underline
export LESS_TERMCAP_us=$'\E[04;33m'       # begin underline

alias ls='ls $LS_OPTIONS'
alias ll='ls $LS_OPTIONS -l'

declare -x CLICOLOR=1
declare -x LSCOLORS=gxfxcxdxbxegedabagacad

declare -x LS_COLORS="no=00:fi=00:di=01;36:ln=02;36:pi=40;33:so=01;35:do=01;35: bd=40; 33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31: *.arj=01;31: *.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31: *.Z=01;31:*.gz=01;31:*. bz2=01;31:*.deb=01;31:*.rpm=01;31: *.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif= 01;35:*.bmp=01;35: *.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01; 35: *.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35: *.mpg=01;35: *.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35: *.dl=01;35:*.xcf=01;35:*. xwd=01;35:*.ogg=01;35:*.mp3=01;35: *.wav=01;35:"
