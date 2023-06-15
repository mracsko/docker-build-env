FROM opensuse/tumbleweed:latest

RUN zypper refresh && zypper update -y && zypper install -y \
        wget \
        git \
        jq \
        ripgrep \
        exa \
        cmake \
        gcc \
        gcc-c++ \
        gzip \
        xz \
        unzip \
        openssl \
        libopenssl-devel \
        mc \
        python311 \
        python311-pip

COPY scripts/github-release-download.sh /usr/local/bin/github-release-download
COPY scripts/java-release-download.sh /usr/local/bin/java-release-download

# Rust
#=====
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | bash -s -- -y
RUN . "$HOME/.cargo/env" && rustup target add wasm32-unknown-unknown \
    && cargo install --locked cargo-audit \
    && cargo install --locked trunk
RUN github-release-download "rust-lang/rust-analyzer" "-x86_64-unknown-linux-gnu.gz" "rust-analyzer" "rust-analyzer"
RUN chmod +x /opt/rust-analyzer/rust-analyzer

# Starship
#=========
RUN . "$HOME/.cargo/env" && cargo install starship --locked
RUN echo 'eval "$(starship init bash)"' >> ~/.bashrc
RUN mkdir -p ~/.cache/starship

# Java
#=====
RUN java-release-download 8
RUN java-release-download 11
RUN java-release-download 17
RUN java-release-download 18
RUN java-release-download 19
RUN java-release-download 20

# Node
#=====
RUN wget -O /tmp/node-18-release.tar.xz -q https://nodejs.org/dist/v18.16.0/node-v18.16.0-linux-x64.tar.xz \
    && mkdir -p /opt/node/18 \
    && tar xJvf /tmp/node-18-release.tar.xz --strip-components=1 -C /opt/node/18
ENV PATH=$PATH:/opt/node/18/bin

# Tools
#=======
#Nushell
RUN github-release-download "nushell/nushell" "-x86_64-unknown-linux-gnu.tar.gz" "nushell" "nu" "--strip-components=1"
RUN ln -s /opt/nushell/nu /bin/nu
#Zellij
RUN github-release-download "zellij-org/zellij" "-x86_64-unknown-linux-musl.tar.gz" "zellij" "zellij" ""
#Dust
RUN github-release-download "bootandy/dust" "-x86_64-unknown-linux-gnu.tar.gz" "dust" "dust" "--strip-components=1"
#Bat
RUN github-release-download "sharkdp/bat" "-x86_64-unknown-linux-gnu.tar.gz" "bat" "bat" "--strip-components=1"
#Fd
RUN github-release-download "sharkdp/fd" "-x86_64-unknown-linux-gnu.tar.gz" "fd" "fd" "--strip-components=1"
#Procs
RUN github-release-download "dalance/procs" "-x86_64-linux.zip" "procs" "procs"

# Neovim
#=======
RUN wget -O /tmp/nvim-release.tar.gz -q https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz \
    && mkdir -p /opt/nvim \
    && tar xzvf /tmp/nvim-release.tar.gz --strip-components=1 -C /opt/nvim \
    && ln -s /opt/nvim/bin/nvim /usr/local/bin/nvim
RUN ln -s /opt/nvim/bin/nvim /usr/local/bin/vim
#LazyVim
RUN git clone https://github.com/LazyVim/starter ~/.config/nvim

# Configuration
#==============
COPY home/.config/nvim/lua/config/* /root/.config/nvim/lua/config/
RUN nvim +"Lazy sync" +qa
RUN nvim +"Lazy health" +qa
RUN nvim +"checkhealth" +qa
COPY home/.config/zellij/* /root/.config/zellij/
COPY home/.config/nushell/* /root/.config/nushell/
COPY home/.config/starship.toml /root/.config/
COPY home/.bashrc /root/

WORKDIR /workdir
ENTRYPOINT /bin/nu
