#!/usr/bin/env bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== XV6 프로젝트 셋업 스크립트 ===${NC}"
echo "이 스크립트는 XV6 프로젝트를 실행하기 위한 필수 도구들을 설치합니다."
echo

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to ask user for confirmation
ask_confirmation() {
    local message=$1
    while true; do
        read -p "${message} (y/n): " yn
        case $yn in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            * ) echo "y 또는 n을 입력해주세요.";;
        esac
    done
}

# Check and install Homebrew
check_and_install_brew() {
    if command_exists brew; then
        echo -e "${GREEN}✓ Homebrew가 이미 설치되어 있습니다.${NC}"
    else
        echo -e "${YELLOW}⚠ Homebrew가 설치되어 있지 않습니다.${NC}"
        if ask_confirmation "Homebrew를 설치하시겠습니까?"; then
            echo "Homebrew 설치 중..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            
            # Add Homebrew to PATH for Apple Silicon Macs
            if [[ $(uname -m) == "arm64" ]]; then
                echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
                eval "$(/opt/homebrew/bin/brew shellenv)"
            fi
            
            echo -e "${GREEN}✓ Homebrew 설치 완료!${NC}"
        else
            echo -e "${RED}✗ Homebrew 없이는 다른 도구들을 설치할 수 없습니다.${NC}"
            exit 1
        fi
    fi
}

# Check and install Just
check_and_install_just() {
    if command_exists just; then
        echo -e "${GREEN}✓ Just가 이미 설치되어 있습니다.${NC}"
    else
        echo -e "${YELLOW}⚠ Just가 설치되어 있지 않습니다.${NC}"
        if ask_confirmation "Just를 설치하시겠습니까?"; then
            echo "Just 설치 중..."
            brew install just
            echo -e "${GREEN}✓ Just 설치 완료!${NC}"
        else
            echo -e "${RED}✗ Just 없이는 이 프로젝트의 빌드 스크립트를 사용할 수 없습니다.${NC}"
            exit 1
        fi
    fi
}

# Check and install Docker
check_and_install_docker() {
    if command_exists docker; then
        echo -e "${GREEN}✓ Docker가 이미 설치되어 있습니다.${NC}"
        
        # Check if Docker is running
        if ! docker info >/dev/null 2>&1; then
            echo -e "${YELLOW}⚠ Docker가 실행되고 있지 않습니다.${NC}"
            echo "Docker Desktop을 실행해주세요."
        fi
    else
        echo -e "${YELLOW}⚠ Docker가 설치되어 있지 않습니다.${NC}"
        if ask_confirmation "Docker를 설치하시겠습니까?"; then
            echo "Docker 설치 중..."
            
            # Install Docker Desktop via Homebrew cask
            brew install --cask docker
            
            echo -e "${GREEN}✓ Docker 설치 완료!${NC}"
            echo -e "${YELLOW}⚠ Docker Desktop을 수동으로 실행해주세요.${NC}"
            echo "Applications 폴더에서 Docker를 찾아 실행하거나, Spotlight 검색으로 'Docker'를 찾아 실행하세요."
        else
            echo -e "${RED}✗ Docker 없이는 이 프로젝트를 실행할 수 없습니다.${NC}"
            exit 1
        fi
    fi
}

# Main installation process
main() {
    echo -e "${BLUE}1. Homebrew 확인 및 설치${NC}"
    check_and_install_brew
    echo
    
    echo -e "${BLUE}2. Just 확인 및 설치${NC}"
    check_and_install_just
    echo
    
    echo -e "${BLUE}3. Docker 확인 및 설치${NC}"
    check_and_install_docker
    echo
    
    echo -e "${GREEN}=== 설치 완료! ===${NC}"
    echo
    echo "이제 다음 명령어를 사용할 수 있습니다:"
    echo -e "${YELLOW}just${NC}                  # 사용 가능한 명령어 목록 보기"
    echo -e "${YELLOW}just build-image${NC}      # Docker 이미지 빌드"
    echo -e "${YELLOW}just build-xv6${NC}        # XV6 빌드하기"
    echo -e "${YELLOW}just run-xv6${NC}          # XV6 실행하기"
    echo -e "${YELLOW}just debug${NC}            # XV6 디버그 모드로 실행하기"
    echo -e "${YELLOW}just clean${NC}            # 빌드 파일 정리하기"
    echo
    echo "빠른 시작:"
    echo -e "${YELLOW}1. just build-image${NC}   # 먼저 Docker 이미지를 빌드하세요"
    echo -e "${YELLOW}2. just build-xv6${NC}     # XV6를 빌드하세요"
    echo -e "${YELLOW}3. just run-xv6${NC}       # XV6를 실행하세요"
    echo
    echo "자세한 사용법은 README.md 파일을 참고하세요."
}

# Run main function
main