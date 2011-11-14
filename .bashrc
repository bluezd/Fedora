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
        PS1='\n\[\e[1;31m\][\w]\[\e[0m\] \[\e[1;35m\][ \[\e[1;36m\]$(/bin/ls -1 | /usr/bin/wc -l | /bin/sed "s: ::g") files \[\e[1;33m\]$(/bin/ls -lah | /bin/grep -m 1 total | /bin/sed "s/total //")b\[\e[0m\] \[\e[1;35m\]]\n`a=$?;if [ $a -ne 0 ]; then echo -ne "\[\e[01;36;41m\]{$a}"; fi`\[\e[01;36m\][\t \u]\[\e[00m\] \[\e[01;34m\]\W`[[ -d .git ]] && echo -ne "\[\e[33;40m\](branch:$(git branch | sed -e "/^ /d" -e "s/* \(.*\)/\1/"))\[\e[01;32m\]\[\e[00m\]"`\[\e[01;34m\] \$ \[\e[00m\]'

else
        PS1='\n[\w] [ $(/bin/ls -1 | /usr/bin/wc -l | /bin/sed "s: ::g") files $(/bin/ls -lah | /bin/grep -m 1 total | /bin/sed "s/total //")b ]\n`a=$?;if [ $a -ne 0 ]; then echo -ne "{$a}"; fi`[\t \u] \W`[[ -d .git ]] && echo -ne "(branch:$(git branch | sed -e "/^ /d" -e "s/* \(.*\)/\1/"))"` \$ '
fi
unset color_prompt
