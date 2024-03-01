#!/usr/bin/env sh

https_proxy_temp=$https_proxy

# git
if [ "$GIT" != "" ]; then
git config --global user.email "UlyssesZhan@gmail.com"
git config --global user.name "Ulysses Zhan"
git config --global credential.helper store
fi

# Install yay
if [ "$YAY" != "" ]; then
if !( command -v yay &>/dev/null ); then
	git clone https://aur.archlinux.org/yay-bin.git
	cd yay
	makepkg -si
	cd ..
	rm -rf yay
fi
fi

# oh-my-zsh
if [ "$OHMYZSH" != "" ]; then
if command -v zsh &>/dev/null; then
	if [ $SHELL != $(which zsh) ]; then
		chsh -s $(which zsh)
	fi
	sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
	curl -o ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/ulyssesys.zsh-theme -L https://github.com/UlyssesZh/ulyssesys/raw/master/ulyssesys.zsh-theme
	cp oh-my-zsh/.zshrc ~
fi
fi

# cheat
if [ "$CHEAT" != "" ]; then
if command -v cheat &>/dev/null; then
	mkdir -p ~/.config/cheat/cheatsheets
	cp cheat/conf.yml ~/.config/cheat/
	git clone https://github.com/cheat/cheatsheets.git ~/.config/cheat/cheatsheets/community
fi
fi

# tmux
if [ "$TMUX" != "" ]; then
if command -v tmux &>/dev/null; then
	git clone https://github.com/gpakosz/.tmux.git ~/.tmux
	ln -s -f ~/.tmux/.tmux.conf ~/.tmux.conf
	cp oh-my-tmux/.tmux.conf.local ~
fi
fi

# jupyter
if [ "$JUPYTER" != "" ]; then
if command -v jupyter &>/dev/null; then
	mkdir -p ~/notebooks
	mkdir -p ~/.jupyter
	cp jupyter/jupyter_notebook_config.json ~/.jupyter
	if command -v iruby &>/dev/null; then
		iruby register --force
	fi
	if command -v wolframscript &>/dev/null; then
		wolframscript -activate
		git clone https://github.com/WolframResearch/WolframLanguageForJupyter.git ~/.local/WolframLanguageForJupyter
		~/.local/WolframLanguageForJupyter/.configure-jupyter.wls add
	fi
fi
fi

# tlmgr
if [ "$TLMGR" != "" ]; then
if command -v tex &>/dev/null; then
	/usr/share/texmf-dist/scripts/texlive/tlmgr.pl --usermode init-usertree
	if [ "$CHINA" != "" ]; then
		export https_proxy=
		/usr/share/texmf-dist/scripts/texlive/tlmgr.pl --usermode option repository https://mirrors.tuna.tsinghua.edu.cn/CTAN/systems/texlive/tlnet
		export https_proxy=$https_proxy_temp
	else
		/usr/share/texmf-dist/scripts/texlive/tlmgr.pl --usermode option repository https://mirrors.rit.edu/CTAN/systems/texlive/tlnet
	fi
	/usr/share/texmf-dist/scripts/texlive/tlmgr.pl --usermode install physics amsfonts amsmath cancel hyperref mathtools mhchem microtype tikz-cd ucs wasysym
	/usr/share/texmf-dist/scripts/texlive/tlmgr.pl --usermode option repository https://mirrors.rit.edu/CTAN/systems/texlive/tlnet
fi
fi
