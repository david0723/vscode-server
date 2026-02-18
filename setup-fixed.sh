#!/bin/bash
# Fixed setup script for VS Code Server

set -e

echo "=== VS Code Server Setup ==="
echo ""

# Ensure .bashrc exists
touch ~/.bashrc

# Install Homebrew
if [ ! -d "$HOME/.linuxbrew/bin/brew" ]; then
    echo "Installing Homebrew..."
    mkdir -p ~/.linuxbrew
    curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip-components=1 -C ~/.linuxbrew
fi

# Add brew to PATH immediately and permanently
echo 'eval "$(~/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc
eval "$(~/.linuxbrew/bin/brew shellenv)"

echo "Homebrew ready: $(which brew)"

# Install nvm
if [ ! -d "$HOME/.nvm" ]; then
    echo "Installing nvm..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
fi

# Add nvm to .bashrc
cat >> ~/.bashrc << 'EOF'

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
EOF

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

echo "nvm ready: $(which nvm 2>/dev/null || echo 'nvm loaded')"

# Install Node.js LTS via nvm
echo "Installing Node.js..."
nvm install 20
nvm use 20
nvm alias default 20

echo "Node ready: $(node --version)"

# Install OpenCode via npm (more reliable than curl)
if ! command -v opencode &> /dev/null; then
    echo "Installing OpenCode via npm..."
    npm install -g opencode-ai
fi

echo "OpenCode ready: $(which opencode)"

# Create opencode config directory
mkdir -p ~/.config/opencode

# Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended || true
fi

# Setup zsh config with tools
if [ -d "$HOME/.oh-my-zsh" ]; then
    echo 'eval "$(~/.linuxbrew/bin/brew shellenv)"' >> ~/.zshrc
    echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.zshrc
    echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.zshrc
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
fi

# Add OpenClaw aliases
echo "" >> ~/.bashrc
echo "# OpenClaw aliases" >> ~/.bashrc
echo 'alias oc="docker exec -it \$(docker ps -q -f name=openclaw) openclaw"' >> ~/.bashrc
echo 'alias oc-shell="docker exec -it \$(docker ps -q -f name=openclaw) bash"' >> ~/.bashrc

if [ -f ~/.zshrc ]; then
    echo "" >> ~/.zshrc
    echo "# OpenClaw aliases" >> ~/.zshrc
    echo 'alias oc="docker exec -it \$(docker ps -q -f name=openclaw) openclaw"' >> ~/.zshrc
    echo 'alias oc-shell="docker exec -it \$(docker ps -q -f name=openclaw) bash"' >> ~/.zshrc
fi

echo ""
echo "=== Setup Complete! ==="
echo ""
echo "Run this to load everything:"
echo "  source ~/.bashrc"
echo ""
echo "Then you can use:"
echo "  brew --version"
echo "  node --version"
echo "  opencode"
echo "  oc"
echo "  oc-shell"
