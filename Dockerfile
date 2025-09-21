# Dockerfile
FROM ubuntu:22.04

# Evita prompts e prepara dependências básicas
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    curl git build-essential pkg-config libssl-dev ca-certificates \
 && rm -rf /var/lib/apt/lists/*

# Usuário não-root para melhorar DX
ARG USER=dev
ARG UID=1000
ARG GID=1000
RUN groupadd -g $GID $USER && useradd -m -u $UID -g $GID -s /bin/bash $USER

USER $USER
WORKDIR /home/$USER/work
SHELL ["/bin/bash", "-lc"]

# Instala Foundry (forge, cast, anvil) com arquitetura específica
RUN curl -L https://foundry.paradigm.xyz | bash && \
    $HOME/.foundry/bin/foundryup

# Adiciona o diretório do Foundry ao PATH
ENV PATH="/home/dev/.foundry/bin:$PATH"

# Verifica se os binários foram instalados corretamente
RUN ls -la /home/dev/.foundry/bin/ && \
    /home/dev/.foundry/bin/forge --version && \
    /home/dev/.foundry/bin/cast --version && \
    /home/dev/.foundry/bin/anvil --version

# Ambiente interativo por padrão
ENTRYPOINT ["/bin/bash"]
