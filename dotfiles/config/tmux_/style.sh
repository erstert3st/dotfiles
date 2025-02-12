##################                            
#  ██╗   ██╗██╗  #
#  ██║   ██║██║  #
#  ██║   ██║██║  #
#  ██║   ██║██║  #
#  ╚██████╔╝██║  #
#   ╚═════╝ ╚═╝  #
##################  

set -g automatic-rename
set -g set-titles on
# Highlight the active window
# set-window-option -g window-status-current-style bg=colour31,fg=white

# Make the status line pretty and add some modules
set -g status-right-length 100
set -g status-left-length 100
set -g status-right "#{E:@catppuccin_status_application}"
set -agF status-right "#{E:@catppuccin_status_cpu}"
set -ag status-right "#{E:@catppuccin_status_session}"
set -ag status-right "#{E:@catppuccin_status_uptime}"
set -agF status-right "#{E:@catppuccin_status_battery}"