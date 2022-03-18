#!/usr/bin/env bash

#
# @file  ZSH installer
# @brief Install script for ZSH and Powerlevel9k

set -o errexit
set -o pipefail
set -o nounset

# @description prepare color display for terminal
#
prepare_color() {
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
}

install_software() {
  SUDO=''
  if (( $EUID != 0 )); then
      SUDO='sudo'
  fi
	$SUDO apt-get update && $SUDO apt-get install -y git coreutils zsh fonts-powerline wget curl unzip
}

install_fonts() {
	printf "${BLUE}Installing nerd-fonts...${NORMAL}\n"
	wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.0.0/Hack.zip
	mkdir hack
	unzip Hack.zip -d hack
	rm Hack.zip
	mv hack /usr/share/fonts/truetype
	fc-cache -f -v
}

install_powerlevel9k() {
	printf "${BLUE}Cloning powerlevel9k...${NORMAL}\n"
	env git clone https://github.com/bhilburn/powerlevel9k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel9k || {
		printf "${RED}Error: git clone of powerlevel9k repo failed${NORMAL}\n"
		exit 1
	}
}

install_powerlevel10k() {
	printf "${BLUE}Cloning powerlevel9k...${NORMAL}\n"
	env git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k || {
		printf "${RED}Error: git clone of powerlevel10k repo failed${NORMAL}\n"
		exit 1
	}
}

install_zsh_plugins() {
	printf "${BLUE}Cloning zsh-autosuggestions...${NORMAL}\n"
	env git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions || {
		printf "${RED}Error: git clone of zsh-autosuggestions repo failed${NORMAL}\n"
		exit 1
	}
	printf "${BLUE}Cloning zsh-syntax-highlighting...${NORMAL}\n"
	env git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting || {
		printf "${RED}Error: git clone of zsh-syntax-highlighting repo failed\${NORMAL}n"
		exit 1
	}
}

set_zsh_config() {
	printf "${BLUE}Editing ~/.zshrc${NORMAL}\n"
	export ZSH="~/.oh-my-zsh"
	tee ~/.zshrc << EOL
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes

export TERM="xterm-256color"
ZSH_THEME="powerlevel10k/powerlevel10k"

HISTSIZE=3000
HISTFILE=~/.zsh_history
SAVEHIST=3000
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt incappendhistory

POWERLEVEL9K_MODE="awesome-patched"
POWERLEVEL9K_CUSTOM_DEBIAN_ICON="echo -e '\uf306' "
POWERLEVEL9K_CUSTOM_DEBIAN_ICON_BACKGROUND=234
POWERLEVEL9K_CUSTOM_DEBIAN_ICON_FOREGROUND=196

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

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

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
EOL
}

install_oh_my_zsh() {
	printf "${BLUE}Installing Oh My Zsh...${NORMAL}\n"
	sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
}

set_zsh_as_default_shell() {
	printf "${BLUE}Sourcing ~/.zshrc${NORMAL}\n"
	/bin/zsh -c "source $HOME/.zshrc"

	printf "${BLUE}Setting zsh as default shell${NORMAL}\n"
	chsh -s /bin/zsh
	source $HOME/.zshrc
}

install() {
  clean_before_start
	install_software
	install_fonts
	install_oh_my_zsh
}

setup() {
	install_powerlevel10k
	install_zsh_plugins
	set_zsh_config
	set_zsh_as_default_shell
}

# @description entrypoint of the script
#
# @arg $1 action to do
#
main() {
  prepare_color
  action=$1

  case "$action" in
      install)
          install
          ;;
      setup)
          setup
          ;;
      help)
          usage
          ;;
      *)
          usage
          ;;
  esac
}

# @description display the help message
#
# @arg $1 string message to display
#
usage() {
	cat <<-EOF
		Usage: $(basename "$0") [command]

		This script automates install of ZSH, usefull plugins and powerlevel9k

		Commands
		 install      First step, install packages and ZSH
		 setup        Second step, install and configuration of plugins
		 help         This message

	EOF
	exit
}

clean_before_start() {
	printf "${RED}Cleanup${NORMAL}\n"
	if [ -d ~/.oh-my-zsh ]; then
		rm -Rf ~/.oh-my-zsh
	fi
	if [ -d ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel9k ]; then
		rm -Rf ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel9k
	fi
	if [ -d ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k ]; then
		rm -Rf ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
	fi
	if [ -d ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions ]; then
		rm -Rf ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
	fi
	if [ -d ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting ]; then
		rm -Rf ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
	fi
}

cleanup() {
	printf "${RED}Cleanup${NORMAL}\n"
	if [ -f Hack.zip ]; then
		rm Hack.zip
	fi
	if [ -d hack ]; then
		rm -Rf hack
	fi
	if [ -d /usr/share/fonts/truetype/hack ]; then
		rm -Rf /usr/share/fonts/truetype/hack
	fi
}
trap cleanup EXIT

main "${@}"