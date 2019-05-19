#!/usr/bin/env bash

function cdd {
  cd "$(ls -d -- */ | fzf)"
}
