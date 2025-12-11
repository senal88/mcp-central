# =============================================================================
# DEVCONTAINER DOCKERFILE - MCP CENTRAL
# Base: Node.js 20 LTS with TypeScript
# =============================================================================

FROM mcr.microsoft.com/devcontainers/typescript-node:1-20-bookworm

# Metadata
LABEL maintainer="Luiz Fernando Moreira Sena <luizfernandomoreirasena@gmail.com>"
LABEL description="MCP Central Development Environment with Context7"
LABEL version="1.0.0"

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Sao_Paulo
ENV PNPM_HOME=/usr/local/share/pnpm
ENV PATH=$PNPM_HOME:$PATH

# Update and install essential packages
RUN apt-get update && apt-get install -y \
    # Build essentials
    build-essential \
    python3 \
    python3-pip \
    # Git tools
    git \
    git-lfs \
    # Network tools
    curl \
    wget \
    net-tools \
    iputils-ping \
    # Text processing
    jq \
    yq \
    # Compression
    zip \
    unzip \
    # Process management
    htop \
    # Shell enhancements
    zsh \
    zsh-syntax-highlighting \
    zsh-autosuggestions \
    # Security
    gnupg2 \
    openssh-client \
    # Database clients
    postgresql-client \
    redis-tools \
    # Cleanup
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install pnpm globally
RUN npm install -g pnpm@latest

# Install global Node.js tools
RUN npm install -g \
    typescript \
    ts-node \
    tsx \
    @changesets/cli \
    prettier \
    eslint \
    vitest

# Configure Git LFS
RUN git lfs install

# Set default shell to zsh
RUN chsh -s $(which zsh) node

# Create workspace directory
RUN mkdir -p /workspaces/mcp-central && \
    chown -R node:node /workspaces

# Switch to non-root user
USER node

# Configure zsh for node user
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Add useful aliases to .zshrc
RUN echo '\n# MCP Central Aliases' >> /home/node/.zshrc && \
    echo 'alias ll="ls -lah"' >> /home/node/.zshrc && \
    echo 'alias gs="git status"' >> /home/node/.zshrc && \
    echo 'alias gp="git pull"' >> /home/node/.zshrc && \
    echo 'alias gc="git commit"' >> /home/node/.zshrc && \
    echo 'alias glog="git log --oneline --graph --all"' >> /home/node/.zshrc && \
    echo 'alias ctx7="cd /workspaces/mcp-central/packages/context7"' >> /home/node/.zshrc && \
    echo 'alias build="pnpm build"' >> /home/node/.zshrc && \
    echo 'alias dev="pnpm dev"' >> /home/node/.zshrc && \
    echo 'alias test="pnpm test"' >> /home/node/.zshrc

# Set working directory
WORKDIR /workspaces/mcp-central

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD node --version && pnpm --version || exit 1

# Default command
CMD ["/bin/zsh"]
