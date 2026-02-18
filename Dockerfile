FROM lscr.io/linuxserver/code-server:latest

USER root

# Install dependencies including zsh
RUN apt-get update && apt-get install -y \
    curl \
    git \
    build-essential \
    procps \
    file \
    jq \
    zsh \
    && rm -rf /var/lib/apt/lists/*

# Install Oh My Zsh for abc user
RUN su - abc -c 'sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended'

# Set zsh as default shell for abc user
RUN chsh -s $(which zsh) abc

# Install Docker CLI
RUN curl -fsSL https://get.docker.com -o /tmp/get-docker.sh \
    && sh /tmp/get-docker.sh --cli-only \
    && rm /tmp/get-docker.sh

# Install Node.js 20 LTS
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Install Homebrew (as abc user)
RUN mkdir -p /home/abc/.linuxbrew \
    && curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip-components=1 -C /home/abc/.linuxbrew \
    && chown -R abc:abc /home/abc/.linuxbrew

# Set up environment for abc user
RUN echo 'eval "$(/home/abc/.linuxbrew/bin/brew shellenv)"' >> /home/abc/.bashrc \
    && echo 'export PATH="/home/abc/.linuxbrew/bin:$PATH"' >> /home/abc/.bashrc

# Install nvm (Node Version Manager) for abc user
RUN su - abc -c 'curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash'

# Add nvm to bashrc
RUN echo 'export NVM_DIR="$HOME/.nvm"' >> /home/abc/.bashrc \
    && echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> /home/abc/.bashrc \
    && echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> /home/abc/.bashrc

# Create OpenCode config directory in persistent location
RUN mkdir -p /config/opencode

# Install OpenCode via install script (more reliable than brew)
RUN curl -fsSL https://raw.githubusercontent.com/opencode-ai/opencode/main/install.sh | bash

# Symlink OpenCode config to persistent location
RUN mkdir -p /home/abc/.config && \
    ln -sf /config/opencode /home/abc/.config/opencode && \
    chown -R abc:abc /config/opencode

# Add OpenClaw aliases
RUN echo 'alias oc="docker exec -it \$(docker ps -q -f name=openclaw) openclaw"' >> /home/abc/.bashrc \
    && echo 'alias oc-shell="docker exec -it \$(docker ps -q -f name=openclaw) bash"' >> /home/abc/.bashrc

USER abc
