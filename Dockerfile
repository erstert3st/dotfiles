
FROM archlinux:latest AS builder

RUN pacman -Syu --noconfirm --needed base-devel git sudo

# User anlegen für makepkg (root darf nicht)
RUN useradd -m user && \
    echo "user ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    mkdir -p /home/user/.local && \
    chown -R user:user /home/user
# Paru aus dem AUR holen, bauen und installieren
USER user
WORKDIR /home/user/.local
RUN git clone https://aur.archlinux.org/paru.git && \
    cd paru && \
    makepkg -si --noconfirm && \
    cd .. && \
    rm -rf paru




FROM archlinux:latest
ENV APP_UID=1001
ENV APP_GID=1001

RUN sed -i 's/^ParallelDownloads = .*/ParallelDownloads = 20/' /etc/pacman.conf && \
    pacman -Syu --noconfirm  && \
    pacman -S --noconfirm  --needed sudo  docker-buildx exa 7zip aspnet-runtime autoconf logcli  fish base-devel base-devel bash bash-completion bat bc bind btop bzip2 curl docker fastfetch yazi  fzf git glances glow grep gzip helm htop httpie imagemagick jq k9s  kubectl  make man-db man-pages md-tui micro nano nano-syntax-highlighting php composer npm net-tools nmap nodejs openssh openssl openvpn   python python-pip python-virtualenv ripgrep ripgrep rsync sed tar terminus-font tmux tmuxp traceroute ttf-fira-code ttf-fira-sans ttf-jetbrains-mono ttf-liberation ttf-opensans ugrep unarchiver unarj unrar unzip vi wget which whois xarchiver xz yq zip zoxide zoxide zsh  && \
    yes | sudo  pacman -Scc  && \
    sudo rm -rf /tmp/* && \
    useradd -m user && \
    usermod -aG docker user && \
    chsh -s /bin/zsh user && \
    chsh -s /bin/zsh root && \
    echo "user ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
# RUN chown -R user:user /home/user && \
#     chmod -R u+rwx /home/user
# USER user dotnet-sdk
####paru

COPY --from=builder /usr/bin/paru /usr/bin/paru
COPY init.sh /init.sh

USER user
RUN paru -S --noconfirm --needed   go-jsonnet grafana-alloy-bin jsonnet-bundler   gdu  ttf-victor-mono  flux-bin  lazydocker lazygit logiops pokemon-colorscripts-git oh-my-posh && \
    paru -S --noconfirm --needed --nocheck kubecolor && \
    yes | paru -Scc   && \
    paru -Qtdq --noconfirm && \
    mkdir ~/.local && \
    cd ~/.local && \
    sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply erstert3st && \
    rm -rf ~/.tmux/plugins/* && \
    tmux new-session -d -s tmp "sleep 0.1; tmux kill-session -t tmp" && \
    ~/.tmux/plugins/tpm/bin/install_plugins  && \
    ~/.local/bin/chezmoi apply --force  && \
    paru -Qtdq --noconfirm && \
    go clean -modcache -cache -testcache && \
    sudo rm -rf ~/.cache/* && \
    sudo rm -rf /tmp/* 

USER root

RUN sudo systemd-machine-id-setup && \
    sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply erstert3st && \
    rm -rf ~/.tmux/plugins/*  && \
    tmux new-session -d -s tmp "sleep 0.1; tmux kill-session -t tmp" && \
    ~/.tmux/plugins/tpm/bin/install_plugins  && \
    chezmoi apply --force  && \
    go clean -modcache -cache -testcache && \
    sudo rm -rf ~/.cache/* || true && \
    sudo pacman -Rns $(pacman -Qdtq) --noconfirm || true 
# ENTRYPOINT [ "/init.sh" ]

# sudo chsh -s /bin/zsh user && \
