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

# Set zsh as default shell
RUN chsh -s $(which zsh) abc

# Install Docker CLI
RUN curl -fsSL https://get.docker.com -o /tmp/get-docker.sh \
    && sh /tmp/get-docker.sh --cli-only \
    && rm /tmp/get-docker.sh

# Install Node.js 20 LTS
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Install nvm system-wide (will be available for all users)
ENV NVM_DIR=/usr/local/nvm
RUN mkdir -p $NVM_DIR \
    && curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash \
    && chmod -R 777 $NVM_DIR

# Add nvm to bashrc for abc user
RUN echo 'export NVM_DIR="/usr/local/nvm"' >> /home/abc/.bashrc \
    && echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> /home/abc/.bashrc

# Install Homebrew to persistent location
RUN mkdir -p /config/homebrew \
    && curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip-components=1 -C /config/homebrew

# Add brew to bashrc for abc user  
RUN echo 'eval "$(/config/homebrew/bin/brew shellenv)"' >> /home/abc/.bashrc

# Create OpenCode config directory in persistent location
RUN mkdir -p /config/opencode \
    && chown -R abc:abc /config/opencode

# Install OpenCode (as root, binary goes to /usr/local/bin)
RUN curl -fsSL https://raw.githubusercontent.com/opencode-ai/opencode/main/install.sh | bash

# Ensure abc owns home config
RUN mkdir -p /home/abc/.config \
    && chown -R abc:abc /home/abc/.config \
    && ln -sf /config/opencode /home/abc/.config/opencode

# Add OpenClaw aliases
RUN echo 'alias oc="docker exec -it \$(docker ps -q -f name=openclaw) openclaw"' >> /home/abc/.bashrc \
    && echo 'alias oc-shell="docker exec -it \$(docker ps -q -f name=openclaw) bash"' >> /home/abc/.bashrc

USER abc
