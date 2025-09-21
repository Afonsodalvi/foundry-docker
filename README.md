# 🚀 Foundry Docker - Guia Completo para Windows e macOS

Este guia te ajudará a configurar e usar o Foundry (Forge, Cast, Anvil) em um ambiente Docker no Windows e macOS, permitindo desenvolvimento de contratos inteligentes Solidity de forma fácil e isolada.

## 📋 Pré-requisitos

### 1. Instalar Docker Desktop para Windows

1. **Baixe o Docker Desktop:**
   - Acesse: https://www.docker.com/products/docker-desktop/
   - Clique em "Download for Windows"

2. **Execute o instalador:**
   - Execute o arquivo `Docker Desktop Installer.exe`
   - Siga as instruções do instalador
   - **Importante:** Marque a opção "Use WSL 2 instead of Hyper-V" se disponível

3. **Reinicie o computador** após a instalação

4. **Inicie o Docker Desktop:**
   - Procure por "Docker Desktop" no menu Iniciar
   - Aguarde o Docker inicializar completamente (ícone da baleia no system tray)

5. **Verifique se está funcionando:**
   ```cmd
   docker --version
   docker-compose --version
   ```

### 2. Instalar Docker Desktop para macOS

1. **Baixe o Docker Desktop:**
   - Acesse: https://www.docker.com/products/docker-desktop/
   - Clique em "Download for Mac"

2. **Execute o instalador:**
   - Execute o arquivo `Docker.dmg`
   - Arraste o Docker para a pasta Applications
   - Siga as instruções do instalador

3. **Inicie o Docker Desktop:**
   - Abra o Docker Desktop da pasta Applications
   - **OU use o comando no terminal:**
   ```bash
   open -a Docker
   ```
   - Aguarde o Docker inicializar completamente (ícone da baleia na barra de menu)

4. **Verifique se está funcionando:**
   ```bash
   docker --version
   docker compose --version
   ```

### 3. Instalar Git (Opcional mas recomendado)

**Para Windows:**
1. Baixe o Git: https://git-scm.com/download/win
2. Instale com as configurações padrão

**Para macOS:**
1. Instale via Homebrew: `brew install git`
2. OU baixe de: https://git-scm.com/download/mac

## 🛠️ Configuração do Projeto

### 1. Criar o diretório do projeto

```cmd
mkdir foundry-docker
cd foundry-docker
```

### 2. Criar os arquivos de configuração

**Crie o arquivo `docker-compose.yml`:**
```yaml
# docker-compose.yml
services:
  foundry:
    image: ghcr.io/foundry-rs/foundry:latest
    working_dir: /work
    volumes:
      - ./:/work
    tty: true
    stdin_open: true
    environment:
      - FOUNDRY_DISABLE_NIGHTLY_WARNING=1
    # mapeia a porta do anvil para usar do host
    ports:
      - "8545:8545"
```

**Crie o arquivo `Dockerfile` (para setup customizado):**
```dockerfile
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

# Instala Foundry (forge, cast, anvil)
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
```

### 3. Criar script helper (opcional)

**Crie o arquivo `foundry.bat` para Windows:**
```batch
@echo off
REM Script helper para usar Foundry com Docker

if "%1"=="shell" (
    docker compose run --rm foundry bash
    goto :eof
)
if "%1"=="anvil" (
    docker compose run --rm foundry anvil
    goto :eof
)

echo Uso: %0 {shell^|anvil}
echo   shell        - Entrar no container
echo   anvil        - Iniciar Anvil (blockchain local)
```

## 🚀 Primeiros Passos

### 1. Verificar se o Docker está funcionando

**Para Windows:**
```cmd
docker --version
docker-compose --version
```

**Para macOS:**
```bash
# Se o Docker não estiver rodando, inicie-o:
open -a Docker

# Aguarde alguns segundos e verifique:
docker --version
docker compose --version
```

### 2. Baixar a imagem do Foundry

```cmd
docker compose pull
```

### 3. **IMPORTANTE: Construir a imagem (se usando Dockerfile customizado)**

Se você está usando o Dockerfile customizado, precisa construir a imagem:

```cmd
# Construir a imagem customizada
docker compose build

# Ou construir sem cache (se houver problemas)
docker compose build --no-cache
```

### 4. Testar o Foundry

```cmd
docker compose run --rm foundry forge --version
```

## 📁 Criando seu Primeiro Projeto

### 1. Entrar no container

```cmd
docker compose run --rm foundry bash
```

### 2. Dentro do container, criar um novo projeto

```bash
# Criar projeto
forge init meu-projeto

# Navegar para o projeto
cd meu-projeto
```

### 3. Verificar a estrutura criada

```bash
ls -la
```

Você verá:
```
meu-projeto/
├── src/           # Contratos Solidity
├── test/          # Testes
├── script/        # Scripts de deploy
├── lib/           # Dependências
├── foundry.toml  # Configuração
└── README.md      # Documentação
```

## 🔧 Trabalhando com o Projeto

### ✅ Método Recomendado: Dentro do Container

```cmd
# 1. Entrar no container
docker compose run --rm foundry bash

# 2. Dentro do container, navegar para o projeto
cd meu-projeto

# 3. Agora você pode usar todos os comandos diretamente
forge build
forge test
forge fmt

# 4. Para sair do container quando terminar
exit
```

### 🔄 Como Sair do Container

Quando você terminar de trabalhar no container, use:

```bash
# Dentro do container, digite:
exit
```

Isso irá:
- ✅ Salvar todos os arquivos criados
- ✅ Sair do container
- ✅ Retornar ao terminal do Windows
- ✅ Manter os arquivos no seu computador

### Comandos Essenciais do Foundry

#### Compilação e Build
```bash
# Compilar todos os contratos
forge build

# Limpar arquivos de build
forge clean

# Verificar configuração
forge config
```

#### Testes
```bash
# Executar todos os testes
forge test

# Executar testes com mais detalhes
forge test -vvv

# Executar teste específico
forge test --match-test testFunctionName

# Executar testes com coverage
forge coverage
```

#### Formatação e Linting
```bash
# Formatar código
forge fmt

# Lint do código
forge lint
```

#### Dependências
```bash
# Instalar dependência
forge install OpenZeppelin/openzeppelin-contracts

# Atualizar dependências
forge update

# Remover dependência
forge remove openzeppelin-contracts
```

#### Deploy e Scripts
```bash
# Executar script
forge script script/Deploy.s.sol

# Deploy em rede local
forge create src/Contract.sol:ContractName --rpc-url http://localhost:8545 --private-key 0x...
```

## 🌐 Usando o Anvil (Blockchain Local)

### 1. Iniciar o Anvil

```cmd
# Em um terminal separado
docker compose run --rm foundry anvil
```

### 2. Configurar MetaMask (Opcional)

- **RPC URL:** `http://localhost:8545`
- **Chain ID:** `31337`
- **Moeda:** `ETH`

### 3. Contas de teste disponíveis

O Anvil cria 10 contas de teste com 10,000 ETH cada. As chaves privadas são exibidas no terminal.

## 🛠️ Desenvolvendo Contratos

### 1. Criar um novo contrato

```bash
# Dentro do container, no diretório do projeto
touch src/MeuContrato.sol
```

### 2. Exemplo de contrato simples

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract MeuContrato {
    uint256 public valor;
    
    function setValor(uint256 _valor) public {
        valor = _valor;
    }
    
    function getValor() public view returns (uint256) {
        return valor;
    }
}
```

### 3. Criar teste para o contrato

```bash
touch test/MeuContrato.t.sol
```

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../src/MeuContrato.sol";

contract MeuContratoTest is Test {
    MeuContrato public contrato;
    
    function setUp() public {
        contrato = new MeuContrato();
    }
    
    function testSetValor() public {
        contrato.setValor(42);
        assertEq(contrato.getValor(), 42);
    }
}
```

## 🔍 Troubleshooting

### Problema: "docker: command not found"
**Solução:** Verifique se o Docker Desktop está rodando e reinicie o terminal.

### Problema: "Cannot connect to the Docker daemon"
**Solução para Windows:** 
1. Reinicie o Docker Desktop
2. Verifique se o WSL 2 está habilitado
3. Execute como administrador se necessário

**Solução para macOS:**
1. **Inicie o Docker Desktop:**
   ```bash
   open -a Docker
   ```
2. Aguarde alguns segundos para o Docker inicializar
3. Verifique se está funcionando:
   ```bash
   docker ps
   ```
4. Se ainda não funcionar, reinicie o Docker Desktop:
   ```bash
   # Parar o Docker
   pkill -f Docker
   # Iniciar novamente
   open -a Docker
   ```

### Problema: "Port 8545 already in use"
**Solução:** 
```cmd
# Encontrar processo usando a porta
netstat -ano | findstr :8545

# Parar o processo (substitua PID pelo número encontrado)
taskkill /PID <PID> /F
```

### Problema: Comandos do Foundry não funcionam
**Solução:** 
1. Verifique se está dentro do container: `docker compose run --rm foundry bash`
2. Navegue para o diretório do projeto: `cd meu-projeto`
3. Teste: `forge --version`

### Problema: Não consigo sair do container
**Solução:** 
```bash
# Dentro do container, use:
exit

# Ou pressione Ctrl+D
```

### Problema: "Image not found" ou "Build failed"
**Solução:** 
```cmd
# Reconstruir a imagem
docker compose build --no-cache

# Ou usar a imagem oficial
# Comente a linha 'build: .' no docker-compose.yml
# E use apenas 'image: ghcr.io/foundry-rs/foundry:latest'
```

## 📚 Comandos Úteis

### Docker

**Comandos básicos (Windows e macOS):**
```bash
# Ver containers rodando
docker ps

# Parar todos os containers
docker stop $(docker ps -q)

# Limpar containers não utilizados
docker system prune

# Ver logs do container
docker compose logs foundry

# Reconstruir imagem
docker compose build

# Reconstruir sem cache
docker compose build --no-cache
```

**Comandos específicos para macOS:**
```bash
# Iniciar Docker Desktop
open -a Docker

# Parar Docker Desktop
pkill -f Docker

# Verificar se Docker está rodando
docker ps

# Reiniciar Docker Desktop
pkill -f Docker && sleep 3 && open -a Docker
```

### Foundry
```bash
# Ver ajuda de um comando
forge build --help

# Listar todos os comandos
forge --help

# Ver versão
forge --version
cast --version
anvil --version
```

## 🎯 Fluxo de Trabalho Recomendado

### 1. Iniciar o ambiente
```cmd
# Entrar no container
docker compose run --rm foundry bash
```

### 2. Criar/editar projeto
```bash
# Se for novo projeto
forge init meu-projeto
cd meu-projeto

# Se projeto já existe
cd meu-projeto
```

### 3. Desenvolver
```bash
# Compilar
forge build

# Testar
forge test

# Formatar
forge fmt
```

### 4. Sair quando terminar
```bash
# Salvar e sair do container
exit
```

### 5. Testar com blockchain local
```cmd
# Em outro terminal
docker compose run --rm foundry anvil
```

## 🎯 Próximos Passos

1. **Explore a documentação oficial:** https://book.getfoundry.sh/
2. **Pratique com exemplos:** Crie contratos simples e teste-os
3. **Use o Anvil:** Desenvolva e teste localmente
4. **Deploy em testnets:** Use Sepolia ou Goerli para testes
5. **Integre com frontend:** Use bibliotecas como ethers.js ou web3.js

## 📞 Suporte

- **Documentação Foundry:** https://book.getfoundry.sh/
- **Discord Foundry:** https://discord.gg/foundry
- **GitHub:** https://github.com/foundry-rs/foundry

---

**🎉 Parabéns!** Você agora tem um ambiente completo de desenvolvimento Solidity com Foundry rodando no Windows via Docker!
