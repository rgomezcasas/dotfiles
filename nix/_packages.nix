# $ nix-env -qaP | grep wget
{ pkgs, ... }:

with pkgs; [
	bat
	cmatrix
	coreutils
	delta
	eza
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
	nodejs_22
	nvd
	ollama
	php83
	php83Packages.composer
	python39
	rustc
	shellcheck
	shfmt
	sl
	tldr
	tmux
	tree
	unrar
	watch
	wget
	yarn
	yt-dlp
	z-lua
	zsh

	# gui
	gum
	kitty
	mas
	pinentry_mac
	skhd
]
