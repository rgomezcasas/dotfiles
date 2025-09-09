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
	nodejs_22
	nvd
	ollama
	pipx
	python3
	python310
	python3Packages.pip
	ripgrep
	rustc
	shellcheck
	shfmt
	sl
	tmux
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
