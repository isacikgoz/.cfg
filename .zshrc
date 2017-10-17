# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=/Users/ibrahim/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME=isacikgoz

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# -------------------------------------------------------------------
# make some commands (potentially) less destructive
# -------------------------------------------------------------------
alias 'rm=rm -i'

# -------------------------------------------------------------------
# some useful aliases
# -------------------------------------------------------------------
alias reset="clear && printf '\e[3J'"

# -------------------------------------------------------------------
# myIP address
# -------------------------------------------------------------------
function myip() {
	ifconfig lo0 | grep 'inet ' | sed -e 's/:/ /' | awk '{print "lo0       : " $2}'
	ifconfig en0 | grep 'inet ' | sed -e 's/:/ /' | awk '{print "en0 (IPv4): " $2 " " $3 " " $4 " " $5 " " $6}'
	ifconfig en0 | grep 'inet6 ' | sed -e 's/ / /' | awk '{print "en0 (IPv6): " $2 " " $3 " " $4 " " $5 " " $6}'
	ifconfig en1 | grep 'inet ' | sed -e 's/:/ /' | awk '{print "en1 (IPv4): " $2 " " $3 " " $4 " " $5 " " $6}'
	ifconfig en1 | grep 'inet6 ' | sed -e 's/ / /' | awk '{print "en1 (IPv6): " $2 " " $3 " " $4 " " $5 " " $6}'
}

# -------------------------------------------------------------------
# add thefuck
# -------------------------------------------------------------------
eval $(thefuck --alias)

# -------------------------------------------------------------------
# marker configuration
# -------------------------------------------------------------------
[[ -s "$HOME/.local/share/marker/marker.sh" ]] && source "$HOME/.local/share/marker/marker.sh"

# -------------------------------------------------------------------
# alt-s shortcut
# -------------------------------------------------------------------
insert_sudo () { zle beginning-of-line; zle -U "sudo " }
zle -N insert-sudo insert_sudo
bindkey "^[s" insert-sudo

# -------------------------------------------------------------------
# turn hidden files on/off in Finder
# -------------------------------------------------------------------
function hiddenOn() { defaults write com.apple.Finder AppleShowAllFiles TRUE ; killall Finder; }
function hiddenOff() { defaults write com.apple.Finder AppleShowAllFiles FALSE ; killall Finder; }

# -------------------------------------------------------------------
# go
# -------------------------------------------------------------------
export GOROOT=/usr/local/opt/go/libexec
export GOPATH=$HOME/.go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

# -------------------------------------------------------------------
# exercism auto-completion utility for zsh
# -------------------------------------------------------------------
if [ -f ~/.config/exercism/exercism_completion.zsh ]; then
	. ~/.config/exercism/exercism_completion.zsh
fi

# -------------------------------------------------------------------
# managing dotfiles is a good thing
# -------------------------------------------------------------------
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'


# -------------------------------------------------------------------
# taking notes from command line is pretty cool and handy
# -------------------------------------------------------------------
note() {
  # start a new heading and append from stdout
  file_name=$HOME"/Documents/notes.md"
  # get the date for datestamp
  cur_date=$(date +"%Y-%m-%d")
  # get the time for time
  cur_time=$(date +"%H:%M:%S")

  if [ ! -z "$1" ]; then
#    clear
    echo "" >> $file_name
    echo "## $cur_date $cur_time $@" >> $file_name
    cat $file_name
    cat - >> $file_name
    clear
    cat $file_name

  # append to file from stdout
  else
#   clear
    cat $file_name
    cat - >> $file_name
    clear
    cat $file_name
  fi
}

notes() {
  cur_dir=$(pwd)

  if [ ! -z "$1" ]; then
# commit and push if args are exactly "push"
    if [ "$1" = "push" ]; then
    cd "$HOME/Documents"
    git add -A
    git commit -m "update notes"
    git push
    cd $cur_dir

# pull from github if args are exactly "pull"
    elif [ "$1" = "pull" ]; then
    cd "$HOME/Documents"
    git pull
    cd $cur_dir

# open vim to search of the args
    else
    escaped=$(echo "$@" | sed s/\ /\\\\\ /g)
    echo $escaped
    vim +/"$escaped" "$HOME/Documents/notes.md"
    fi

# just open the notes
  else
  vim + "$HOME/Documents/notes.md"
  fi
}
