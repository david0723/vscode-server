#!/bin/bash
# One-time setup script for VS Code Server
# Run this inside the VS Code terminal after first start
# All installations will persist across container restarts

set -e

echo "=== VS Code Server Setup ==="
echo "Installing tools to persistent volumes..."
echo ""

# Install Homebrew if not present
if [ ! -d "$HOME/.linuxbrew" ]; then
    echo "Installing Homebrew..."
    mkdir -p ~/.linuxbrew
    curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip-components=1 -C ~/.linuxbrew
    eval "$(~/.linuxbrew/bin/brew shellenv)"
    echo 'eval "$(~/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc
else
    echo "Homebrew already installed"
    eval "$(~/.linuxbrew/bin/brew shellenv)"
fi

# Install nvm if not present
if [ ! -d "$HOME/.nvm" ]; then
    echo "Installing nvm..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.bashrc
    echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.bashrc
else
    echo "nvm already installed"
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
fi

# Install OpenCode if not present
if ! command -v opencode &> /dev/null; then
    echo "Installing OpenCode..."
    curl -fsSL https://raw.githubusercontent.com/opencode-ai/opencode/main/install.sh | bash
else
    echo "OpenCode already installed"
fi

# Install zsh if not default
if [ "$SHELL" != "/usr/bin/zsh" ]; then
    echo "Setting up zsh..."
    sudo chsh -s $(which zsh) $USER
    
    # Install Oh My Zsh if not present
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        echo "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    fi
    
    # Add tools to zshrc
    echo 'eval "$(~/.linuxbrew/bin/brew shellenv)"' >> ~/.zshrc
    echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.zshrc
    echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.zshrc
else
    echo "zsh already default shell"
fi

# Add OpenClaw aliases (works for both bash and zsh)
if ! grep -q "alias oc=" ~/.bashrc; then
    echo "Adding OpenClaw aliases..."
    echo 'alias oc="docker exec -it \$(docker ps -q -f name=openclaw) openclaw"' >> ~/.bashrc
    echo 'alias oc-shell="docker exec -it \$(docker ps -q -f name=openclaw) bash"' >> ~/.bashrc
fi

if [ -f ~/.zshrc ] && ! grep -q "alias oc=" ~/.zshrc; then
    echo 'alias oc="docker exec -it \$(docker ps -q -f name=openclaw) openclaw"' >> ~/.zshrc
    echo 'alias oc-shell="docker exec -it \$(docker ps -q -f name=openclaw) bash"' >> ~/.zshrc
fi

echo ""
echo "=== Setup Complete! ==="
echo "Tools installed and persisted:"
echo "  - Homebrew (~/.linuxbrew)"
echo "  - nvm (~/.nvm)"
echo "  - OpenCode (~/.local/bin/opencode)"
echo "  - zsh (if not already default)"
echo ""
echo "Aliases added:"
echo "  oc       - Run openclaw commands"
echo "  oc-shell - Enter openclaw container"
echo ""
echo "Restart your terminal or run: source ~/.bashrc"
