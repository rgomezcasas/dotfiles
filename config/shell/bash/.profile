ulimit -u 10000

# >>> dory cli >>>
DORY_CLI_BIN="/Users/rafa.gomez/.dory/bin"
case ":$PATH:" in
  *":$DORY_CLI_BIN:"*) ;;
  *) export PATH="$DORY_CLI_BIN:$PATH" ;;
esac
# <<< dory cli <<<
