#!/usr/bin/env bash

https_proxy_temp=$https_proxy

# termux
if [ "$TERMUX" != "" ] && [ "$TERMUX_VERSION" != "" ]; then
	termux-change-repo
	pkg upgrade
	pkg install git gh vim tree atuin
	atuin import bash
	if [ -f $HOME/.zsh_history ]; then
		atuin import zsh
	fi
	gh extension install vilmibm/gh-user-status
	if [ ! -d $HOME/storage ]; then
		termux-setup-storage
	fi
	sed -i 's/# *allow-external-apps = true/allow-external-apps = true/' $HOME/.termux/termux.properties
	sed -i "s|# *extra-keys = \[\['ESC','/','-'|extra-keys = [['ESC','ENTER','BKSP'|" $HOME/.termux/termux.properties
	sed -i "s|# *\['TAB','CTRL'|              \['TAB','CTRL'|" $HOME/.termux/termux.properties
	curl -o $HOME/.termux/colors.properties -L https://github.com/termux/termux-styling/raw/refs/heads/master/app/src/main/assets/colors/base16-google-light.properties
	curl -o $HOME/.termux/font.ttf -L https://github.com/termux/termux-styling/raw/refs/heads/master/app/src/main/assets/fonts/JetBrains-Mono.ttf
	if ! command -v rish &>/dev/null && [ -d "/storage/emulated/0/ulysses/rish" ]; then
		mkdir -p $HOME/.local/bin $HOME/.local/share/rish
		install -m 700 /storage/emulated/0/ulysses/rish/rish $HOME/.local/bin/rish
		install -m 400 /storage/emulated/0/ulysses/rish/rish_shizuku.dex $HOME/.local/share/rish/rish_shizuku.dex
		sed -i 's|^BASEDIR=.*|BASEDIR=$HOME/.local/share/rish|' $HOME/.local/bin/rish
		sed -i 's/RISH_APPLICATION_ID="PKG"/RISH_APPLICATION_ID=com.termux/' $HOME/.local/bin/rish
	fi
fi

# scripts
if [ "$SCRIPTS" != "" ]; then
	cp -r scripts $HOME
	curl -o $HOME/scripts/peroutine -L https://github.com/UlyssesZh/peroutine/raw/master/peroutine
	chmod +x $HOME/scripts/*
fi

# git
if [ "$GIT" != "" ]; then
	git config --global user.email "UlyssesZhan@gmail.com"
	git config --global user.name "Ulysses Zhan"
	git config --global credential.helper store
fi

# Install yay
if [ "$YAY" != "" ]; then
	git clone https://aur.archlinux.org/yay-bin.git
	cd yay-bin
	makepkg -si
	cd ..
	rm -rf yay-bin
fi

# oh-my-zsh
if [ "$OHMYZSH" != "" ]; then
	if command -v zsh &>/dev/null; then
		if [ $SHELL != $(which zsh) ]; then
			if [ "$TERMUX_VERSION" != "" ]; then
				chsh -s zsh
			else
				chsh -s $(which zsh)
			fi
		fi
	fi
	sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
	git clone https://github.com/chisui/zsh-nix-shell.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/nix-shell
	curl -o ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/ulyssesys.zsh-theme -L https://github.com/UlyssesZh/ulyssesys/raw/master/ulyssesys.zsh-theme
	mkdir -p ~/.config/atuin
	cp oh-my-zsh/atuin.config.toml ~/.config/atuin/config.toml
	cp oh-my-zsh/zshrc ~/.zshrc
fi

# cheat
if [ "$CHEAT" != "" ]; then
	mkdir -p ~/.config/cheat/cheatsheets/personal
	cp cheat/conf.yml ~/.config/cheat/
	git clone https://github.com/cheat/cheatsheets.git ~/.config/cheat/cheatsheets/community
fi

# tmux
if [ "$OHMYTMUX" != "" ]; then
	git clone https://github.com/gpakosz/.tmux.git ~/.tmux
	ln -s -f ~/.tmux/.tmux.conf ~/.tmux.conf
	cp oh-my-tmux/tmux.conf.local ~/.tmux.conf.local
fi

# jupyter
if [ "$JUPYTER" != "" ]; then
	mkdir -p $HOME/pynb
	mkdir -p $HOME/.jupyter
	cp jupyter/jupyter_notebook_config.json $HOME/.jupyter
	sed -i 's|/home/ulysses|$HOME|g' $HOME/.jupyter/jupyter_notebook_config.json
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

# rime
if [ "$RIME" != "" ]; then
mkdir -p $HOME/.local/bin $HOME/.local/share
if [ "$TERMUX_VERSION" != "" ]; then
	rime_dir=/storage/emulated/0/ulysses/trime
else
	rime_dir=$HOME/.config/ibus/rime
fi
if [ ! -d $rime_dir ]; then
	mkdir -p $rime_dir
fi
echo "#!/usr/bin/env bash"$'\n'"cd \$HOME/.local/share/plum"$'\n'"rime_dir=$rime_dir ./rime-install \"\$@\"" > $HOME/.local/bin/rime-install
chmod +x $HOME/.local/bin/rime-install
git clone https://github.com/rime/plum.git $HOME/.local/share/plum
rime_dir=$rime_dir $HOME/.local/bin/rime-install UlyssesZh/rime-config/all-packages.conf
curl -o $rime_dir/default.custom.yaml -L https://github.com/UlyssesZh/rime-config/raw/refs/heads/master/default.custom.yaml
curl -o $rime_dir/luna_pinyin.custom.yaml -L https://github.com/UlyssesZh/rime-config/raw/refs/heads/master/luna_pinyin.custom.yaml
if [ "$TERMUX_VERSION" != "" ]; then
	curl -o $rime_dir/pc.trime.yaml -L https://github.com/UlyssesZh/rime-config/raw/refs/heads/master/pc.trime.yaml
	curl -o $rime_dir/tongwenfeng.trime.custom.yaml -L https://github.com/UlyssesZh/rime-config/raw/refs/heads/master/tongwenfeng.trime.custom.yaml
else
	curl -o $rime_dir/ibus_rime.custom.yaml -L https://github.com/UlyssesZh/rime-config/raw/refs/heads/master/ibus_rime.custom.yaml
fi
fi

# drawings
if [ "$DRAWINGS" != "" ]; then
if [ $TERMUX_VERSION != "" ]; then
	if [ ! -d $HOME/storage ]; then
		termux-setup-storage
	fi
	mkdir -p /storage/emulated/0/DCIM/drawings
	curl -o '/storage/emulated/0/DCIM/drawings/78(.png' -L https://github.com/UlyssesZh/drawings/raw/refs/heads/master/78%28/78%28.png
	curl -o '/storage/emulated/0/DCIM/drawings/78(.jpg' -L https://github.com/UlyssesZh/drawings/raw/refs/heads/master/78%28/78%28.jpg
	curl -o '/storage/emulated/0/DCIM/drawings/pink_blocks.png' -L https://github.com/UlyssesZh/drawings/raw/refs/heads/master/pink_blocks/pink_blocks.png
	mkdir -p '/storage/emulated/0/Notifications/ulysses-ringtones'
	curl -o /storage/emulated/0/Notifications/ulysses-ringtones/6.ogg -L https://github.com/UlyssesZh/ringtones/raw/refs/heads/gh-action-output/build/6.ogg
	curl -o /storage/emulated/0/Notifications/ulysses-ringtones/42.ogg -L https://github.com/UlyssesZh/ringtones/raw/refs/heads/gh-action-output/build/42.ogg
	curl -o /storage/emulated/0/Notifications/ulysses-ringtones/255.ogg -L https://github.com/UlyssesZh/ringtones/raw/refs/heads/gh-action-output/build/255.ogg
	curl -o /storage/emulated/0/Notifications/ulysses-ringtones/1108.ogg -L https://github.com/UlyssesZh/ringtones/raw/refs/heads/gh-action-output/build/1108.ogg
else
	mkdir -p $HOME/Pictures
	git clone https://github.com/UlyssesZh/drawings.git $HOME/Pictures/drawings
fi
fi

# mpv
if [ "$MPV" != "" ]; then
	mkdir -p ~/.config/mpv/scripts
	cp mpv/* ~/.config/mpv
	curl -o ~/.config/mpv/scripts/bdanmaku.lua -L https://raw.githubusercontent.com/UlyssesZh/bdanmaku/refs/heads/master/bdanmaku.lua
fi

# vscode
if [ "$VSCODE" != "" ]; then
	mkdir -p ~/.config/Code/User
	cp vscode/{settings,keybindings}.json ~/.config/Code/User
	mkdir -p ~/.config/VSCodium/User
	ln -s ~/.config/Code/User/{settings,keybindings}.json -t ~/.config/VSCodium/User
fi

# ghostty
if [ "$GHOSTTY" != "" ]; then
	mkdir -p ~/.config/ghostty
	cp ghostty/config ~/.config/ghostty
	cp ghostty/xdg-terminals.list ~/.config
fi
