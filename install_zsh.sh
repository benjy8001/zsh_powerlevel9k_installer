#!/bin/bash
# Install script for ZSH and Powerlevel9k

set -e
set -u

if which tput >/dev/null 2>&1; then
	ncolors=$(tput colors)
fi
if [ -t 1 ] && [ -n "$ncolors" ] && [ "$ncolors" -ge 8 ]; then
	RED="$(tput setaf 1)"
	GREEN="$(tput setaf 2)"
	YELLOW="$(tput setaf 3)"
	BLUE="$(tput setaf 4)"
	BOLD="$(tput bold)"
	NORMAL="$(tput sgr0)"
else
	RED=""
	GREEN=""
	YELLOW=""
	BLUE=""
	BOLD=""
	NORMAL=""
fi

command -v git >/dev/null 2>&1 || {
	echo "${RED}Error: git is not installed${NORMAL}"
	exit 1
}

command -v tee >/dev/null 2>&1 || {
	echo "${RED}Error: tee is not installed${NORMAL}"
	exit 1
}

apt-get install -y git zsh fonts-powerline wget curl

printf "${BLUE}Installing nerd-fonts...${NORMAL}\n"
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.0.0/Hack.zip
mkdir hack
unzip Hack.zip -d hack
rm Hack.zip
mv hack /usr/share/fonts/truetype
fc-cache -f -v

printf "${BLUE}Cloning powerlevel9k...${NORMAL}\n"
env git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k || {
	printf "${RED}Error: git clone of powerlevel9k repo failed${NORMAL}\n"
	exit 1
}
printf "${BLUE}Cloning zsh-autosuggestions...${NORMAL}\n"
env git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions || {
	printf "${RED}Error: git clone of zsh-autosuggestions repo failed${NORMAL}\n"
	exit 1
}
printf "${BLUE}Cloning zsh-syntax-highlighting...${NORMAL}\n"
env git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting || {
	printf "${RED}Error: git clone of zsh-syntax-highlighting repo failed\${NORMAL}n"
	exit 1
}

printf "${BLUE}Editing ~/.zshrc${NORMAL}\n"
tee ~/.zshrc << END
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
  export ZSH="/root/.oh-my-zsh"

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes

export TERM="xterm-256color"
ZSH_THEME="powerlevel9k/powerlevel9k"

HISTSIZE=3000
HISTFILE=~/.zsh_history
SAVEHIST=3000
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt incappendhistory

POWERLEVEL9K_CUSTOM_DEBIAN_ICON="echo -e '\uf306' "
POWERLEVEL9K_CUSTIM_DEBIAN_ICON_BACKGROUND=234
POWERLEVEL9K_CUSTIM_DEBIAN_ICON_FOREGROUND=196

POWERLEVEL9K_BACKGROUND_JOBS_FOREGROUND=232
POWERLEVEL9K_BACKGROUND_JOBS_BACKGROUND=178

POWERLEVEL9K_TIME_FORMAT="%D{\ue383 %H:%M \uf073 %d.%m.%y}"

POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX="\u256d\u2500 "
POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="\u2570\uf460 "

POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(custom_debian_icon root_indicator dir dir_writable vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status background_jobs time battery)
POWERLEVEL9K_PROMPT_ON_NEWLINE=true

# Set list of themes to load
# Setting this variable when ZSH_THEME=random
# cause zsh load theme from this variable instead of
# looking in ~/.oh-my-zsh/themes/
# An empty array have no effect
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

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
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  colored-man-pages
)

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
END

printf "${BLUE}Installing Oh My Zsh...${NORMAL}\n"
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

printf "${BLUE}Sourcing ~/.zshrc${NORMAL}\n"
/bin/zsh -c 'source ~/.zshrc'

printf "${BLUE}Setting zsh as default shell${NORMAL}\n"
chsh -s /bin/zsh
