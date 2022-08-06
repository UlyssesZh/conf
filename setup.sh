#!/usr/bin/sh

# oh-my-zsh
if command -v zsh &>/dev/null; then
	chsh -s $(which zsh)
	sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
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
rvm install 3.1.2

# tmux
if command -v tmux &>/dev/null; then
	git clone https://github.com/gpakosz/.tmux.git ~/.tmux
	ln -s -f ~/.tmux/.tmux.conf ~/.tmux.conf
	cp oh-my-tmux/.tmux.conf.local ~
fi

# pip and gem packages
if command -v pip3 &>/dev/null; then
	pip3 install --upgrade pip
	pip3 install pandas numpy torch matplotlib jupyter you-get youtube-dl spotdl scdl
fi
if command -v gem &>/dev/null; then
	gem install jekyll rails iruby sciruby
fi

# jupyter
if command -v jupyter &>/dev/null; then
	mkdir -p ~/notebooks
	mkdir -p ~/.jupyter
	cp jupyter/jupyter_notebook_config.py ~/.jupyter
	if command -v iruby &>/dev/null; then
		iruby register --force
	fi
	if command -v wolframscript &>/dev/null; then
		wolframscript -activate
		git clone https://github.com/WolframResearch/WolframLanguageForJupyter.git ~/.local/WolframLanguageForJupyter
		~/.local/WolframLanguageForJupyter/.configure-jupyter.wls add
	fi
fi
