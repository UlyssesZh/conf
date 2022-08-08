#!/usr/bin/sh

https_proxy_temp=$https_proxy

# git
git config --global user.email "UlyssesZhan@gmail.com"
git config --global user.name "Ulysses Zhan"
git config --global credential.helper store

# Install yay
if !( command -v yay &>/dev/null ); then
	git clone https://aur.archlinux.org/yay.git
	cd yay
	makepkg -si
	cd ..
	rm -rf yay
fi

# Install AUR packages
yay --needed --noconfirm -S fpp icdiff cppman

# oh-my-zsh
if command -v zsh &>/dev/null; then
	if [ $SHELL != $(which zsh) ]; then
		chsh -s $(which zsh)
	fi
	sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
	cp oh-my-zsh/ulyssesys.zsh-theme ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/
	cp oh-my-zsh/.zshrc ~
fi

# cheat
if command -v go &>/dev/null; then
	go install github.com/cheat/cheat/cmd/cheat@latest
	mkdir -p ~/.config/cheat/cheatsheets
	cp cheat/conf.yml ~/.config/cheat/
	git clone https://github.com/cheat/cheatsheets.git ~/.config/cheat/cheatsheets/community
fi

# rvm
gpg2 --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
\curl -sSL https://get.rvm.io | bash -s stable
source ~/.rvm/scripts/rvm
~/.rvm/bin/rvm install 3.1.2
~/.rvm/bin/rvm use 3.1.2

# tmux
if command -v tmux &>/dev/null; then
	git clone https://github.com/gpakosz/.tmux.git ~/.tmux
	ln -s -f ~/.tmux/.tmux.conf ~/.tmux.conf
	cp oh-my-tmux/.tmux.conf.local ~
fi

# pip and gem packages
if [ $CHINA != "" ]; then
	export https_proxy=
	if command -v pip3 &>/dev/null; then
		pip3 install you-get youtube-dl spotdl scdl -i https://pypi.tuna.tsinghua.edu.cn/simple
	fi
	if command -v gem &>/dev/null; then
		gem sources --add https://mirrors.tuna.tsinghua.edu.cn/rubygems/ --remove https://rubygems.org/
		gem install jekyll rails iruby sciruby
		gem sources --add https://rubygems.org/ --remove https://mirrors.tuna.tsinghua.edu.cn/rubygems/
	fi
	export https_proxy=$https_proxy_temp
else
	if command -v pip3 &>/dev/null; then
		pip3 install you-get youtube-dl spotdl scdl
	fi
	if command -v gem &>/dev/null; then
		gem install jekyll rails iruby sciruby
	fi
fi

# jupyter
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

# tlmgr
if command -v tex &>/dev/null; then
	/usr/share/texmf-dist/scripts/texlive/tlmgr.pl --usermode init-usertree
	if [ $CHINA != "" ]; then
		export https_proxy=
		/usr/share/texmf-dist/scripts/texlive/tlmgr.pl --usermode option repository https://mirrors.tuna.tsinghua.edu.cn/CTAN/systems/texlive/tlnet
		export https_proxy=$https_proxy_temp
	else
		/usr/share/texmf-dist/scripts/texlive/tlmgr.pl --usermode option repository https://mirrors.rit.edu/CTAN/systems/texlive/tlnet
	fi
	/usr/share/texmf-dist/scripts/texlive/tlmgr.pl --usermode install physics amsfonts amsmath cancel hyperref mathtools mhchem microtype tikz-cd ucs wasysym
	/usr/share/texmf-dist/scripts/texlive/tlmgr.pl --usermode option repository https://mirrors.rit.edu/CTAN/systems/texlive/tlnet
fi
