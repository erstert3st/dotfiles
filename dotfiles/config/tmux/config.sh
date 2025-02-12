source bindings.sh
source plugins.sh
source style.sh
set -g mouse on
set-option -g xterm-keys on
#set-option -g default-shell $SHELL
set -g history-limit 10000
#set -g default-terminal "xterm-256color"
set -g default-terminal "screen-256color"
set -g status-interval 3

set -g allow-passthrough on   # Allow programs in the pane to bypass tmux (e.g. for image preview)
set -g renumber-windows on # Automatically renumber windows when one is closed

#set -g default-terminal "ghostty"
# set -g default-terminal "iTerm2"
run '~/.tmux/plugins/tpm/tpm'
run 'set enable-bracketed-paste off'