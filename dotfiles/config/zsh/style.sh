#ZSH_THEME="bira"
current_shell="$(basename "$SHELL")"
eval "$(oh-my-posh init "$current_shell" --config "$HOME/dotfiles/emodipt-extend.omp.json")"
# Check if both pokemon-colorscripts and fastfetch are installed
if hash pokemon-colorscripts 2>/dev/null && hash fastfetch 2>/dev/null; then
  RANDOM=$(date +%N)
  choice=$(( RANDOM % 2 ))
  if (( choice == 0 )); then
    pokemon-colorscripts --no-title -s -r 1-4 \
      | fastfetch --logo-type file-raw --logo-height 20 --logo-width 5 --logo -
  else
    pokemon-colorscripts --no-title -r 1-4 \
      | fastfetch --logo-type file-raw --logo-height 20 --logo-width 5 --logo -
  fi
fi