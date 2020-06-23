#!/usr/bin/env bash

docs::eval() {
  eval "$(docpars -h "$(grep "^##?" "$0" | cut -c 5-)" : "$@")"
}
