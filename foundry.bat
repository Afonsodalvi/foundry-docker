@echo off
REM Script helper para usar Foundry com Docker

if "%1"=="init" (
    docker compose run --rm foundry forge init %2
    goto :eof
)
if "%1"=="build" (
    docker compose run --rm foundry sh -c "cd my-project && forge build"
    goto :eof
)
if "%1"=="test" (
    docker compose run --rm foundry sh -c "cd my-project && forge test"
    goto :eof
)
if "%1"=="shell" (
    docker compose run --rm foundry bash
    goto :eof
)
if "%1"=="anvil" (
    docker compose run --rm foundry anvil
    goto :eof
)

echo Uso: %0 {init^|build^|test^|shell^|anvil}
echo   init ^<nome^>  - Criar novo projeto
echo   build        - Compilar projeto
echo   test         - Executar testes
echo   shell        - Entrar no container
echo   anvil        - Iniciar Anvil (blockchain local)
