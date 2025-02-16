###############################################################
# ██████╗ ██╗███╗   ██╗██████╗ ██╗███╗   ██╗ ██████╗ ███████╗ #
# ██╔══██╗██║████╗  ██║██╔══██╗██║████╗  ██║██╔════╝ ██╔════╝ #
# ██████╔╝██║██╔██╗ ██║██║  ██║██║██╔██╗ ██║██║  ███╗███████╗ #
# ██╔══██╗██║██║╚██╗██║██║  ██║██║██║╚██╗██║██║   ██║╚════██║ #
# ██████╔╝██║██║ ╚████║██████╔╝██║██║ ╚████║╚██████╔╝███████║ #
# ╚═════╝ ╚═╝╚═╝  ╚═══╝╚═════╝ ╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚══════╝ #
###############################################################                                                        

#magic key
set -g prefix C-Space 
unbind C-b
bind C-e send-prefix
bind r source-file ~/.tmux.conf \; display-message " Config reloaded!"
bind Space run-shell "tmux split-window -h -l 15; tmux select-pane -t 0; tmux split-window -v; tmux split-window -v; tmux select-pane -t 0"

#bind Space run-shell 'tmux split-window -h -l 15'
#bind Space run-shell "tmux split-window -h -l 15 '#{pane_current_path}'; tmux select-pane -t 0; tmux split-window -v '#{pane_current_path}'; tmux split-window -v '#{pane_current_path}'; tmux select-pane -t 0"

#bind R  kill-server && rm -rf /tmp/tmux-*
#tmux list-keys 

bind % split-window -h -c "#{pane_current_path}"

bind \" split-window -v -c "#{pane_current_path}"

# New window in same path
bind c new-window -c "#{pane_current_path}"
#set enable-bracket-paste off
#tmux list-commands
# prefix + c new window
    #prefix + n/p  next/prev window
    #prefix , rename
# prefix + : commandmode
# prefix + s list session