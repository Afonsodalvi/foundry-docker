# 🎯 Exemplo Prático de Uso - Método Correto

## ✅ Fluxo Recomendado: Entrar no Container

### 1. Verificar se o Docker está funcionando
```cmd
docker --version
docker-compose --version
```

### 2. Baixar a imagem do Foundry
```cmd
docker compose pull
```

### 3. Entrar no container (MÉTODO CORRETO)
```cmd
docker compose run --rm foundry bash
```

### 4. Dentro do container, criar um novo projeto
```bash
forge init meu-primeiro-projeto
```

### 5. Navegar para o projeto
```bash
cd meu-primeiro-projeto
```

### 6. Verificar a estrutura
```bash
ls -la
```

### 7. Compilar o projeto
```bash
forge build
```

### 8. Executar testes
```bash
forge test
```

### 9. Executar testes com detalhes
```bash
forge test -vvv
```

### 10. Ver o contrato padrão
```bash
cat src/Counter.sol
```

### 11. Editar um contrato
```bash
# Usar nano (ou seu editor preferido)
nano src/Counter.sol
```

### 12. Executar testes novamente
```bash
forge test -vvv
```

### 13. **IMPORTANTE: Sair do container quando terminar**
```bash
exit
```

## 🚫 Método que NÃO funciona bem

```cmd
# ❌ NÃO faça isso - não cria a pasta corretamente
docker compose run --rm foundry forge init meu-projeto
```

## ✅ Método que funciona perfeitamente

```cmd
# ✅ Faça assim - entre no container primeiro
docker compose run --rm foundry bash

# Dentro do container
forge init meu-projeto
cd meu-projeto
forge build
forge test

# Quando terminar, saia do container
exit
```

## 🔄 Como Sair do Container

### Opção 1: Comando exit
```bash
# Dentro do container, digite:
exit
```

### Opção 2: Atalho de teclado
```bash
# Pressione Ctrl+D
```

### O que acontece quando você sai:
- ✅ Todos os arquivos são salvos automaticamente
- ✅ Você volta ao terminal do Windows
- ✅ Os arquivos ficam disponíveis no seu computador
- ✅ O container é removido automaticamente

## 🔧 Comandos Essenciais (dentro do container)

### Para compilar:
```bash
forge build
```

### Para testar:
```bash
forge test
forge test -vvv  # Mais detalhes
```

### Para formatar código:
```bash
forge fmt
```

### Para iniciar blockchain local:
```bash
# Em outro terminal (fora do container)
docker compose run --rm foundry anvil
```

## 📁 Estrutura do Projeto

```
meu-primeiro-projeto/
├── src/                    # Contratos Solidity
│   └── Counter.sol        # Contrato exemplo
├── test/                   # Testes
│   └── Counter.t.sol      # Teste do contrato
├── script/                 # Scripts de deploy
│   └── Counter.s.sol       # Script de deploy
├── lib/                    # Dependências
│   └── forge-std/         # Biblioteca padrão
├── foundry.toml           # Configuração
└── README.md              # Documentação
```

## 🎯 Resumo do Fluxo Correto

1. **Sempre entre no container primeiro:**
   ```cmd
   docker compose run --rm foundry bash
   ```

2. **Dentro do container, trabalhe normalmente:**
   ```bash
   forge init projeto
   cd projeto
   forge build
   forge test
   ```

3. **Quando terminar, saia do container:**
   ```bash
   exit
   ```

4. **Para blockchain local, use outro terminal:**
   ```cmd
   docker compose run --rm foundry anvil
   ```

## 💡 Dicas Importantes

- **Sempre use `exit`** quando terminar de trabalhar
- **Os arquivos são salvos automaticamente** quando você sai
- **Use outro terminal** para o Anvil (blockchain local)
- **O container é removido automaticamente** quando você sai

## 🚀 Próximos Passos

1. **Modifique o contrato Counter.sol**
2. **Crie seus próprios testes**
3. **Use o Anvil para testar localmente**
4. **Deploy em testnets quando estiver pronto**

---

**💡 Dica:** Sempre use o método de entrar no container primeiro. É mais confiável e permite usar todos os comandos do Foundry normalmente!
