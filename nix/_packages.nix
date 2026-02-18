# $ nix-env -qaP | grep wget
{ pkgs, ... }:

with pkgs; [
	ast-grep
	bat
	cargo
	cmatrix
	coreutils
	delta
	eza
	fd
	ffmpeg
	findutils
	fzf
	gh
	git
	git-lfs
	gnupg
	go
	goku
	gradle
	htop
	hyperfine
	jdk21
	nodejs_24
	nvd
	pipx
	python313
	python3Packages.pip
	ripgrep
	shellcheck
	shfmt
	sl
	tmux
	terminal-notifier
	tree
	unrar
	uv
	watch
	wget
	yarn
	yt-dlp
	z-lua
	zsh

	# gui
	gum
	mas
	pinentry_mac
	skhd
]
