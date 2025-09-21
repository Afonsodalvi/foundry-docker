# 🔧 Opções de Setup - Foundry Docker

## 📋 Duas Opções Disponíveis

### 🚀 Opção 1: Imagem Oficial (Recomendada para iniciantes)

**Vantagens:**
- ✅ Mais simples e rápida
- ✅ Sempre atualizada
- ✅ Menos configuração
- ✅ Funciona imediatamente

**Como usar:**
```cmd
# 1. Baixar a imagem
docker compose pull

# 2. Entrar no container
docker compose run --rm foundry bash

# 3. Usar normalmente
forge init meu-projeto
```

**docker-compose.yml:**
```yaml
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
    ports:
      - "8545:8545"
```

### 🛠️ Opção 2: Dockerfile Customizado (Para usuários avançados)

**Vantagens:**
- ✅ Controle total sobre o ambiente
- ✅ Dependências específicas
- ✅ Configurações personalizadas
- ✅ Usuário não-root (mais seguro)

**Como usar:**
```cmd
# 1. Construir a imagem
docker compose build

# 2. Entrar no container
docker compose run --rm foundry bash

# 3. Usar normalmente
forge init meu-projeto
```

**docker-compose.yml:**
```yaml
services:
  foundry:
    build: .
    working_dir: /work
    volumes:
      - ./:/work
    tty: true
    stdin_open: true
    environment:
      - FOUNDRY_DISABLE_NIGHTLY_WARNING=1
    ports:
      - "8545:8545"
```

## 🎯 Qual Escolher?

### Para Iniciantes:
- **Use a Opção 1** (imagem oficial)
- Mais simples e rápida
- Funciona imediatamente

### Para Desenvolvedores Avançados:
- **Use a Opção 2** (Dockerfile customizado)
- Controle total sobre o ambiente
- Configurações específicas

## 🔄 Como Alternar Entre as Opções

### Para usar imagem oficial:
```yaml
services:
  foundry:
    image: ghcr.io/foundry-rs/foundry:latest
    # build: .  # Comente esta linha
```

### Para usar Dockerfile customizado:
```yaml
services:
  foundry:
    # image: ghcr.io/foundry-rs/foundry:latest  # Comente esta linha
    build: .  # Descomente esta linha
```

## 🚀 Comandos Essenciais

### Para imagem oficial:
```cmd
docker compose pull
docker compose run --rm foundry bash
```

### Para Dockerfile customizado:
```cmd
docker compose build
docker compose run --rm foundry bash
```

### Para reconstruir (Dockerfile customizado):
```cmd
docker compose build --no-cache
```

## 🔍 Troubleshooting

### Problema: "Image not found"
**Solução:** Use `docker compose pull` para baixar a imagem oficial

### Problema: "Build failed"
**Solução:** 
1. Verifique se o Dockerfile está correto
2. Use `docker compose build --no-cache`
3. Ou mude para a imagem oficial

### Problema: "Permission denied"
**Solução:** Use o Dockerfile customizado (usuário não-root)

---

**💡 Dica:** Comece com a imagem oficial e mude para o Dockerfile customizado quando precisar de mais controle!
