###############################################################  1 = nedded
#  ██████╗ ██╗     ██╗   ██╗ ██████╗ ██╗███╗   ██╗███████╗    #  2 = os nedded
#  ██╔══██╗██║     ██║   ██║██╔════╝ ██║████╗  ██║██╔════╝    #  3 = check
#  ██████╔╝██║     ██║   ██║██║  ███╗██║██╔██╗ ██║███████╗    #  4 = wtf
#  ██╔═══╝ ██║     ██║   ██║██║   ██║██║██║╚██╗██║╚════██║    #
#  ██║     ███████╗╚██████╔╝╚██████╔╝██║██║ ╚████║███████║    #     
#  ╚═╝     ╚══════╝ ╚═════╝  ╚═════╝ ╚═╝╚═╝  ╚═══╝╚══════╝    #
############################################################### 
# Install `tpm` if needed.

  #&& ~/.tmux/plugins/tpm/bin/install_plugins'
if-shell "test ! -d ~/.tmux/plugins/tpm" \
  "run-shell 'mkdir -p ~/.tmux/plugins/tpm && git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm'" 

# tpm plugin manager
set -g @plugin 'tmux-plugins/tpm'
# set -g @plugin 'tmux-plugins/tmux-sensible' # add configs

# # set -g @plugin 'tmux-plugins/tmux-resurrect'    # Persist tmux sessions after computer restart
# # set -g @plugin 'tmux-plugins/tmux-continuum'    # Automatically saves sessions every 15 minutes
# # # Resurrect
# # set -g @resurrect-capture-pane-contents 'on'
# # set -g @continuum-restore 'on'


set -g @plugin 'thewtex/tmux-mem-cpu-load'
# # set -g @plugin 'hendrikmi/tmux-cpu-mem-monitor' # CPU and memory info

# set -g @plugin '27medkamal/tmux-session-wizard'
# #set-environment -g TMUX_PLUGIN_MANAGER_PATH ~/.tmux/plugins
# # 3Plugin to yank (copy) text from tmux to the system clipboard
# set -g @plugin 'tmux-plugins/tmux-yank'
#set -g @yank_with_mouse off # or 'on'
# run ~/.config/tmux/plugins/catppuccin/tmux/catppuccin.tmux

# Plugin to manage tmux plugins using TPM (Tmux Plugin Manager)
#set -g @plugin 'tmux-plugins/tmux-cpu'
# Plugin to display battery status within tmux
#set -g @plugin 'tmux-plugins/tmux-battery'

# Plugin for an interactive terminal file searcher, allowing you to quickly navigate files in tmux
# set -g @plugin '2kabhishek/tmux-tilit'
# set -g @tilit-easymode 'off'
#prefix + alt(hold) <- -> ...

#set -g @catppuccin_flavor 'macchiato' # latte, frappe, macchiato or mocha