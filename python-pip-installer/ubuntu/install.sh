#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

install_pip() {
    local python_cmd="$1"
    local pip_cmd="$2"
    local get_pip_url="https://bootstrap.pypa.io/get-pip.py"

    echo -e "${YELLOW}Attempting to install pip for ${python_cmd}...${NC}"

    if command_exists "apt"; then
        echo -e "${YELLOW}Trying apt installation...${NC}"
        if [ "$python_cmd" = "python3" ]; then
            sudo apt install -y python3-pip && return 0
        else
            sudo apt install -y python-pip && return 0
        fi
    fi

    if command_exists "curl"; then
        echo -e "${YELLOW}Trying curl + ${python_cmd} method...${NC}"
        if curl -sSL "$get_pip_url" | "$python_cmd" - && return 0; then
            echo -e "${GREEN}Successfully installed via curl!${NC}"
            return 0
        fi
    fi

    echo -e "${YELLOW}Falling back to manual download...${NC}"
    if command_exists "wget"; then
        wget -O /tmp/get-pip.py "$get_pip_url"
    elif command_exists "curl"; then
        curl -sSL -o /tmp/get-pip.py "$get_pip_url"
    else
        echo -e "${RED}ERROR: Neither wget nor curl is available. Install one of them first.${NC}"
        return 1
    fi

    "$python_cmd" /tmp/get-pip.py || {
        echo -e "${RED}Failed to install pip for ${python_cmd}${NC}"
        return 1
    }

    if ! command_exists "$pip_cmd"; then
        echo -e "${RED}ERROR: Pip still not found after installation!${NC}"
        return 1
    fi

    echo -e "${GREEN}Successfully installed ${pip_cmd}!${NC}"
    return 0
}

echo -e "${YELLOW}=== PIP INSTALLATION SCRIPT ===${NC}"

if ! command_exists "curl" && ! command_exists "wget"; then
    echo -e "${YELLOW}Installing curl for downloads...${NC}"
    sudo apt update && sudo apt install -y curl
fi

if command_exists "python3"; then
    install_pip "python3" "pip3"
else
    echo -e "${RED}Python3 not found! Installing Python3 first...${NC}"
    sudo apt update && sudo apt install -y python3
    install_pip "python3" "pip3"
fi

if command_exists "python2"; then
    install_pip "python2" "pip2"
elif command_exists "python" && [[ $(python --version 2>&1) == Python\ 2* ]]; then
    install_pip "python" "pip"
fi

echo -e "\n${GREEN}=== INSTALLATION SUMMARY ===${NC}"
echo "Python 3: $(command -v python3) → $(python3 --version 2>&1)"
echo "Pip3: $(command -v pip3) → $(pip3 --version 2>&1 || echo 'Not installed')"
echo "Python 2: $(command -v python2) → $(python2 --version 2>&1 || echo 'Not installed')"
echo "Pip2: $(command -v pip2) → $(pip2 --version 2>&1 || echo 'Not installed')"

echo -e "\n${GREEN}Done!${NC}"
