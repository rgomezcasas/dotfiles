selector::select() {
  options=""
  while read -r data; do
    options="$options\n$data"
  done

  printf "$options" | choose -c 31d6e0
}
