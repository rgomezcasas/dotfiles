# $ nix-env -qaP | grep wget
{ pkgs, ... }:

with pkgs; [
	bat
	cargo
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
	pipx
	python3
	python3Packages.pip
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
	mas
	pinentry_mac
	skhd
]
