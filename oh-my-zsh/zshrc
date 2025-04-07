export ZSH="$HOME/.oh-my-zsh"
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
plugins=(git zsh-syntax-highlighting dotenv nix-shell)

source $ZSH/oh-my-zsh.sh

#export MANPATH="/usr/local/man:$MANPATH"
#export LANG=en_US.UTF-8
export EDITOR=vim
#export ARCHFLAGS="-arch x86_64"

#alias zshconfig="mate ~/.zshrc"
#alias ohmyzsh="mate ~/.oh-my-zsh"

# Added by the user
#. ~/.local/share/rtx/plugins/go/set-env.zsh
export PATH=$PATH:$HOME/.cabal/bin:$HOME/.local/bin:$HOME/scripts
command -v mise &> /dev/null && alias rtx=mise || true
command -v rtx &> /dev/null && eval "$(rtx activate zsh)" || true
command -v thefuck &> /dev/null && eval "$(thefuck --alias)" || true
command -v ng &> /dev/null && source <(ng completion script) || true
command -v colormake &> /dev/null && alias make=colormake || true

autoload -Uz compinit && compinit

[ -f "$HOME/.ghcup/env" ] && source "$HOME/.ghcup/env" || true # ghcup-env

command -v doas &> /dev/null && alias sudo=doas || true
command -v atuin &> /dev/null  && eval "$(atuin init zsh)" || true

[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local" || true
