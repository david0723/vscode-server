FROM lscr.io/linuxserver/code-server:latest

USER root

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    build-essential \
    procps \
    file \
    jq \
    && rm -rf /var/lib/apt/lists/*

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

# Install OpenCode via install script (more reliable than brew)
RUN curl -fsSL https://raw.githubusercontent.com/opencode-ai/opencode/main/install.sh | bash

# Add OpenClaw aliases
RUN echo 'alias oc="docker exec -it \$(docker ps -q -f name=openclaw) openclaw"' >> /home/abc/.bashrc \
    && echo 'alias oc-shell="docker exec -it \$(docker ps -q -f name=openclaw) bash"' >> /home/abc/.bashrc

USER abc
