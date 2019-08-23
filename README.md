<h1 align="center">
  <code>rgomezcasas/dotfiles</code>
</h1>

<img src="https://user-images.githubusercontent.com/1331435/36755901-df80a99c-1c0d-11e8-86cd-2f0f0003d28b.gif" alt="rgomezcasas/dotfiles">

<p align="center">
  <a href="install-linux.sh">Install</a>&nbsp;&nbsp;&nbsp;
  <a href="terminal">Terminal</a>&nbsp;&nbsp;&nbsp;
  <a href="git/.gitconfig">Git configuration</a>
</p>

## 🏎 Performance
I like to open/split the iTerm and immediately have all operative. I reached this goal with this configuration.

```bash
λ ~ TIMEFMT=$'real %E\tuser %U\tsys %S'; repeat 10 {time zsh -i -c exit}
real 0.01s      user 0.00s      sys 0.00s
real 0.01s      user 0.00s      sys 0.00s
real 0.01s      user 0.00s      sys 0.00s
real 0.01s      user 0.00s      sys 0.00s
real 0.01s      user 0.00s      sys 0.01s
real 0.01s      user 0.00s      sys 0.00s
real 0.01s      user 0.00s      sys 0.00s
real 0.01s      user 0.00s      sys 0.01s
real 0.01s      user 0.00s      sys 0.00s
real 0.01s      user 0.00s      sys 0.00s
```

This is a way faster than using oh-my-zsh with the minimal setup.

## 🧐 What's inside?
 * A [lot of custom binaries to play](bin)
 * [Aliases](terminal/_aliases), [aliases](terminal/_aliases) and [aliases](terminal/_aliases)
 * [Intellij](editors/intellij), [sublime](editors/sublime-text-3) and [vim](editors/vim) configurations
 * [Git](git/.gitconfig) configuration, and [git binaries](git/bin)
 * Some [clojure](langs/clojure), [scala](langs/scala) and [php](langs/php) configurations
 * zsh a la fish (with suggestions, autocompletion, ...)
 * macOS settings for
   - alfred
   - brew
   - iTerm
   - Karabiner Elements
   - Spectacle
 * And much more!

## 🍩 Inspirations
 * https://github.com/Tuurlijk/dotfiles

## ⚖️ License
The MIT License (MIT). Please see [License](LICENSE) for more information.
