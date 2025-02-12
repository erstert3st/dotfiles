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
# set -g status-right " #{cpu -i 3} |  #{mem} "
set -g status-right '#[fg=green,bg=default,bright]#(tmux-mem-cpu-load) #[fg=red,dim,bg=default]#(uptime | cut -f 4-5 -d " " | cut -f 1 -d ",") #[fg=white,bg=default]%a%l:%M:%S %p#[default] #[fg=blue]%Y-%m-%d'
#bar
#dont work
set -g status-left-length 200  # default: 10
set -g status-right-length 200 # default: 10
set -g status-justify centre

# Highlight the active window
# set-window-option -g window-status-current-style bg=colour31,fg=white

# Make the status line pretty and add some modules
