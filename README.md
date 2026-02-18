# VS Code Server with Persistent Tools

Standard VS Code Server (linuxserver/code-server) with persistent volumes for installed tools.

## Quick Start

1. **Deploy on Hostinger** using Git source:
   - Git URL: `https://github.com/david0723/vscode-server.git`
   - Environment variables: `CODE_PASSWORD`, `SUDO_PASSWORD`

2. **Open VS Code** at `http://your-vps-ip:8443`

3. **Run setup script** (one time only):
   ```bash
   bash /config/workspace/setup.sh
   ```

4. **Restart terminal** or run `source ~/.bashrc`

## What's Persisted

These directories survive container restarts/rebuilds:

| Volume | Contents |
|--------|----------|
| `homebrew` | Homebrew package manager |
| `nvm` | Node Version Manager |
| `opencode-config` | OpenCode settings & API keys |
| `zsh-config` | zsh/Oh My Zsh config |
| `bashrc` | Shell aliases & config |

## Available Tools After Setup

```bash
brew              # Homebrew package manager
nvm               # Node version manager
opencode          # OpenCode CLI
oc                # OpenClaw shortcut
oc-shell          # Enter OpenClaw container
docker            # Docker CLI (via socket mount)
```

## Adding More Tools

Install anything you need — it will persist:

```bash
brew install ripgrep fzf
cargo install exa
pip install some-tool
```

## Updating VS Code Server

Just restart the container — your tools remain:
```bash
# Via Hostinger panel or API
curl -X POST .../docker/${PROJECT_ID}/restart
```

## Notes

- Uses standard `lscr.io/linuxserver/code-server:latest` image
- No custom Dockerfile needed
- All persistence via Docker volumes
- Setup script is idempotent (safe to run multiple times)
