export ZSH="/home/`whoami`/.oh-my-zsh"
ZSH_THEME="ulyssesys"
#ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )
#CASE_SENSITIVE="true"
HYPHEN_INSENSITIVE="true"
#DISABLE_AUTO_UPDATE="true"
#DISABLE_UPDATE_PROMPT="true"
#export UPDATE_ZSH_DAYS=13
# Uncomment the following line if pasting URLs and other text is messed up.
#DISABLE_MAGIC_FUNCTIONS=true
#DISABLE_LS_COLORS="true"
# Uncomment the following line to disable auto-setting terminal title.
#DISABLE_AUTO_TITLE="true"
#ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
#DISABLE_UNTRACKED_FILES_DIRTY="true"
#HIST_STAMPS="mm/dd/yyyy"
#ZSH_CUSTOM=/path/to/new-custom-folder
plugins=(git zsh-syntax-highlighting dotenv)

source $ZSH/oh-my-zsh.sh

#export MANPATH="/usr/local/man:$MANPATH"
#export LANG=en_US.UTF-8
export EDITOR=vim
#export ARCHFLAGS="-arch x86_64"

#alias zshconfig="mate ~/.zshrc"
#alias ohmyzsh="mate ~/.oh-my-zsh"

# Added by the user
#. ~/.local/share/rtx/plugins/go/set-env.zsh
export PATH=$PATH:$HOME/.cabal/bin:$HOME/.local/bin
[ -x "$(command -v mise)" ] && alias rtx=mise
[ -x "$(command -v rtx)" ] && eval "$(rtx activate zsh)"

[ -x "$(command -v thefuck)" ] && eval $(thefuck --alias)

if [ -x "$(command -v ng)" ]; then
	# Load Angular CLI autocompletion.
	source <(ng completion script)
fi

[ -x "$(command -v colormake)" ] && alias make=colormake

autoload -Uz compinit && compinit

[ -f "/home/ulysses/.ghcup/env" ] && source "/home/ulysses/.ghcup/env" # ghcup-env

[ -x "$(command -v doas)" ] && alias sudo=doas

[ -x "$(command -v atuin)" ] && eval "$(atuin init zsh)"
