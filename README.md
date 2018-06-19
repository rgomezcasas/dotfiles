<h1 align="center">
  <code>rgomezcasas/dotfiles</code>
</h1>

<p align="center">
  <sub>Go to <a href="https://www.youtube.com/channel/UC9IKtxn9AIGelnYmwYr0Lxw" target="_blank"><code>codely.tv</code></a> to know how to use it. Also you can follow me on <a href="https://twitter.com/rafaoe" target="_blank"><code>Twitter</code></a> for more.</sub>
</p>

<img src="https://user-images.githubusercontent.com/1331435/36755901-df80a99c-1c0d-11e8-86cd-2f0f0003d28b.gif" alt="rgomezcasas/dotfiles">

<p align="center">
  <a href="install.sh">Install</a>&nbsp;&nbsp;&nbsp;
  <a href="console">Terminal</a>&nbsp;&nbsp;&nbsp;
  <a href="git/.gitconfig">Git configuration</a>&nbsp;&nbsp;&nbsp;
  <a href="editors/intellij/settings.jar">Intellij settings</a>
</p>

## Performance
I like to open/split the iTerm and immediately have all operative. I reached this goal with this configuration.

I've tried to use plain zsh code and no dependencies (not reached, but almost there :)

```bash
λ ~/.dotfiles on master ✗ for i in $(seq 1 10); do /usr/bin/time zsh -i -c exit; done | awk '{print $1}'
        0.05 real         0.03 user         0.02 sys
        0.05 real         0.03 user         0.02 sys
        0.05 real         0.03 user         0.02 sys
        0.05 real         0.03 user         0.02 sys
        0.05 real         0.03 user         0.02 sys
        0.05 real         0.03 user         0.01 sys
        0.05 real         0.03 user         0.02 sys
        0.05 real         0.03 user         0.02 sys
        0.05 real         0.03 user         0.02 sys
        0.05 real         0.03 user         0.02 sys
```

This is a way faster than using oh-my-zsh with the minimal setup.

## What's inside?
 * A [lot of custom binaries to play](bin)
 * [Aliases](console/_aliases), [aliases](console/_aliases) and [aliases](console/_aliases)
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
