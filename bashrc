# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
    screen-256color) color_prompt=yes;;
    tmux-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

## bash function
function git_branch {
    ref=$(git symbolic-ref HEAD 2> /dev/null) || return;
    echo "("${ref#refs/heads/}") ";
}

if [ "$color_prompt" = yes ]; then
    PS1="[\[\033[1;32m\]\u@\h:\w\[\033[0m\]] \[\033[0m\]\[\033[1;36m\]\$(git_branch)\n\$ "
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$(git_branch)\n\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

## Personal Setting ##
if [ -f /usr/local/bin/vim ]; then
    export EDITOR=/usr/local/bin/vim
elif [ -f /usr/bin/vim ]; then
    export EDITOR=/usr/bin/vim
else
    export EDITOR=/usr/bin/vi
fi

# terminal 256 color
export TERM="screen-256color"
if [ -f /usr/bin/tmux ] || [ -f /usr/local/bin/tmux ]; then
	alias tmux="TERM=screen-256color-bce tmux -u"
fi

if [ -d /usr/local/sbin ]; then
    export PATH="$PATH":/usr/local/sbin
fi

## OS Setting
OS=`uname`
if [ $OS == "Darwin" ]; then
    #alias vim='mvim -v'
    alias dissec='open -a Google\ Chrome\ Canary --args --disable-web-security'
    if [ -d /usr/local/bin ]; then
        export PATH=/usr/local/bin:"$PATH"
    fi
    if [ -d /opt/homebrew/bin ]; then
        export PATH=/opt/homebrew/bin:"$PATH"
    fi
    export CLICOLOR=1
    export EVENT_NOKQUEUE=1
fi

## Useful alias
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
# open github repository
function openGithub {
  eval "open `git remote -v | grep github.com | grep fetch  | head -1 | cut -f2 | cut -d' ' -f1 | sed -e 's/git:/http:/'`"
}
alias ghopen="openGithub"

## Programming Tools
Z_FILE=/usr/local/etc/profile.d/z.sh
if [ -f $Z_FILE ]; then
	. $Z_FILE
elif [ -f "/opt/homebrew/etc/profile.d/z.sh" ]; then
  . "/opt/homebrew/etc/profile.d/z.sh"
fi
WIN_Z=/home/linuxbrew/.linuxbrew/etc/profile.d/z.sh
if [ -f $WIN_Z ];then
  . $WIN_Z
fi
SERVER_Z=$HOME/resources/z/z.sh
if [ -f $SERVER_Z ]; then
  . $SERVER_Z
fi
# Go
export GO111MODULE=auto
if [ -d $HOME/mygo ]; then
  export GOPATH=$HOME/mygo
  export PATH=$PATH:$GOPATH/bin
elif [ -d $WORKDIR/mygo ]; then
  export GOPATH=$WORKDIR/mygo
  export PATH=$PATH:$GOPATH/bin
elif [ -d $HOME/go ]; then
  export GOPATH=$HOME/go
  export PATH=$PATH:$GOPATH/bin
fi
if [ -d /snap/go/current ]; then
  export GOROOT=/snap/go/current
fi

# nvm - nodejs version control 
NVM_DIR=$HOME/.nvm
if [ -s "/usr/local/opt/nvm/nvm.sh" ]; then
  source "/usr/local/opt/nvm/nvm.sh"
elif [ -s "/opt/homebrew/opt/nvm/nvm.sh" ]; then
  source "/opt/homebrew/opt/nvm/nvm.sh"
elif [ -d $NVM_DIR ]; then
	source $NVM_DIR/nvm.sh
  source $NVM_DIR/bash_completion
fi
if [ -s "$NVM_DIR/bash_completion" ]; then
  source "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
elif [ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ]; then
  source "/usr/local/opt/nvm/etc/bash_completion.d/nvm"
fi

NPMRC=~/.npmrc
if [ -f $NPMRC ]; then
  export NPM_TOKEN=`cat ~/.npmrc | grep authToken | sed 's/^.*authToken=\([0-9a-z\-]*\)/\1/'`
fi

# gvm
GVM=$HOME/.gvm/scripts/gvm
if [ -f $GVM ]; then
  source $GVM
fi

# rustup
RUSTUP=$HOME/.cargo/env
if [ -f $RUSTUP ]; then
  source $RUSTUP
fi
if [ -d $HOME/.cargo/bin ]; then
  export PATH="$HOME/.cargo/bin:$PATH"
fi

## Useful Tools
PERSONAL_DIR=~/Programming/resources
if [ -d $PERSONAL_DIR ]; then
    export PATH="$PATH":"$PERSONAL_DIR"
fi

## Setup path for google development
## depot_tools for chrome 
## appengine for appengine
DEP_DIR=~/Programming/resources/depot_tools
if [ -d $DEP_DIR ]; then
	export PATH="$PATH":"$DEP_DIR"
fi

## python setting
if [ -d $HOME/.pyenv ]; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
#  eval "$(pyenv init -)"
#  eval "$(pyenv virtualenv-init -)"
fi

### Added by the Heroku Toolbelt
if [ -d /usr/local/heroku/bin ]; then
    export PATH="/usr/local/heroku/bin:$PATH"
fi

if [ -d $HOME/.yarn/bin ]; then
    export PATH="$HOME/.yarn/bin:$PATH"
fi

### tools
ipgroup () {
  rg -N -o -w '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' $@ | sort | uniq -c | sort -n
}

