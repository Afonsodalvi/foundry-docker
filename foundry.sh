#!/bin/bash
# Script helper para usar Foundry com Docker

case "$1" in
    "init")
        docker compose run --rm foundry forge init "$2"
        ;;
    "build")
        docker compose run --rm foundry sh -c "cd my-project && forge build"
        ;;
    "test")
        docker compose run --rm foundry sh -c "cd my-project && forge test"
        ;;
    "shell")
        docker compose run --rm foundry bash
        ;;
    "anvil")
        docker compose run --rm foundry anvil
        ;;
    *)
        echo "Uso: $0 {init|build|test|shell|anvil}"
        echo "  init <nome>  - Criar novo projeto"
        echo "  build        - Compilar projeto"
        echo "  test         - Executar testes"
        echo "  shell        - Entrar no container"
        echo "  anvil        - Iniciar Anvil (blockchain local)"
        ;;
esac
