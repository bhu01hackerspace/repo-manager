#!/bin/bash

# ==============================================
# REPOSITORY MANAGER - Biblioteca de Ferramentas
# Version: 1.0
# Author: BHU01 Hackerspace
# GitHub: https://github.com/bhu01hackerspace/repo-manager
# ==============================================

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

# Configurações
VERSION="1.0"
BASE_DIR="$HOME/repo-library"
REPOS_DIR="$BASE_DIR/repos"
CONFIG_DIR="$BASE_DIR/config"
LOG_DIR="$BASE_DIR/logs"
CONFIG_FILE="$CONFIG_DIR/repos.conf"
LOG_FILE="$LOG_DIR/repo-manager.log"

# Criar diretórios necessários
setup_directories() {
    mkdir -p "$REPOS_DIR" "$CONFIG_DIR" "$LOG_DIR"
    touch "$CONFIG_FILE"
    touch "$LOG_FILE"
}

# Log de operações
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

# Verificar argumentos de linha de comando
check_args() {
    case "$1" in
        --add|-a)
            shift
            if [ $# -eq 2 ]; then
                echo "$1|$2" >> "$CONFIG_FILE"
                echo -e "${GREEN}[✓] Repositório adicionado: $1${NC}"
                log "Adicionado via CLI: $1 - $2"
                exit 0
            else
                echo "Uso: repo-manager --add <nome> <url>"
                exit 1
            fi
            ;;
        --update-all|-u)
            update_all
            exit 0
            ;;
        --list|-l)
            list_repositories
            exit 0
            ;;
        --version|-v)
            echo "Repository Manager v$VERSION"
            exit 0
            ;;
        --help|-h)
            show_help
            exit 0
            ;;
    esac
}

# Mostrar ajuda
show_help() {
    echo "Repository Manager v$VERSION - Gerenciador de Repositórios"
    echo ""
    echo "Uso: repo-manager [opções]"
    echo ""
    echo "Opções:"
    echo "  -a, --add <nome> <url>    Adicionar novo repositório"
    echo "  -u, --update-all          Atualizar todos os repositórios"
    echo "  -l, --list                Listar todos os repositórios"
    echo "  -v, --version             Mostrar versão"
    echo "  -h, --help                Mostrar esta ajuda"
    echo ""
    echo "Sem opções, inicia o modo interativo"
}

# [O restante do script principal aqui - igual ao anterior, mas com as funções list_repositories, add_repository, etc.]
# Nota: Incluir todas as funções do script anterior aqui

# Função principal
main() {
    setup_directories
    
    # Verificar argumentos
    if [ $# -gt 0 ]; then
        check_args "$@"
    fi
    
    # Modo interativo
    while true; do
        show_header
        show_menu
        read option
        
        case $option in
            1) add_repository ;;
            2) list_repositories ;;
            3) download_all ;;
            4)
                list_repositories
                if [ -s "$CONFIG_FILE" ]; then
                    echo ""
                    read -p "Digite o nome do repositório: " repo_name
                    repo_url=$(grep "^$repo_name|" "$CONFIG_FILE" | cut -d'|' -f2)
                    if [ ! -z "$repo_url" ]; then
                        download_repo "$repo_name" "$repo_url"
                    else
                        echo -e "${RED}[!] Repositório não encontrado!${NC}"
                    fi
                    read -p "Pressione ENTER para continuar..."
                fi
                ;;
            5) remove_repository ;;
            6) execute_tool ;;
            7) update_all ;;
            8) check_status ;;
            9) import_repos ;;
            10) export_repos ;;
            0) 
                echo -e "${GREEN}[+] Saindo...${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}[!] Opção inválida!${NC}"
                sleep 2
                ;;
        esac
        
        if [[ $option != "0" ]]; then
            echo ""
            read -p "Pressione ENTER para continuar..."
        fi
    done
}

# Executar programa
main "$@"
