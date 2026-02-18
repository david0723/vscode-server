# VS Code Server with OpenCode

Custom VS Code Server image with:
- Homebrew package manager
- OpenCode CLI pre-installed
- Docker CLI for container management
- OpenClaw integration aliases

## Usage

### Build and run locally
```bash
docker compose up --build -d
```

### Access VS Code
Open http://localhost:8443 (or your VPS IP:8443)

### Pre-configured aliases
```bash
oc          # Run openclaw commands in the openclaw container
oc-shell    # Enter the openclaw container shell
opencode    # OpenCode CLI
brew        # Homebrew package manager
```

## Deploy on Hostinger

Use the Hostinger Docker Manager with Git source:
- Git URL: `https://github.com/david0723/vscode-server.git`
- Environment variables: `CODE_PASSWORD`, `SUDO_PASSWORD`
