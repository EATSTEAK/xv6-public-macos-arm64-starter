# xv6 빌드 및 실행을 위한 Justfile

# Docker 이미지 이름
IMAGE_NAME := "xv6-amd64"
CONTAINER_NAME := "xv6-container"
XV6_PATH := "xv6-public"

# Docker 이미지 빌드
build-image:
    docker build --platform=linux/amd64 -t {{IMAGE_NAME}} .

# Docker 컨테이너에서 xv6 빌드
build-xv6:
    docker run --platform=linux/amd64 --rm -v $(pwd):/host -v $(pwd)/{{XV6_PATH}}:/workspace/xv6-public {{IMAGE_NAME}} bash -c "cd /workspace/xv6-public && make clean && make"

# Docker 컨테이너에서 xv6 실행 (nox 모드 - 그래픽 없음)
run-xv6:
    @echo "xv6를 텍스트 모드에서 실행합니다. 종료하려면 Ctrl+A, X를 누르세요."
    docker run --platform=linux/amd64 --rm -it --privileged -v $(pwd):/host -v $(pwd)/{{XV6_PATH}}:/workspace/xv6-public {{IMAGE_NAME}} bash -c "cd /workspace/xv6-public && make qemu-nox"

# Docker 컨테이너에 bash 쉘로 접속
shell:
    docker run --platform=linux/amd64 --rm -it --privileged -v $(pwd):/host -v $(pwd)/{{XV6_PATH}}:/workspace/xv6-public {{IMAGE_NAME}} bash

# xv6 소스 정리
clean:
    docker run --platform=linux/amd64 --rm -v $(pwd):/host -v $(pwd)/{{XV6_PATH}}:/workspace/xv6-public {{IMAGE_NAME}} bash -c "cd /workspace/xv6-public && make clean"

# Docker 이미지 제거
clean-image:
    docker rmi {{IMAGE_NAME}} 2>/dev/null || true

# 전체 정리 (빌드 파일 + Docker 이미지)
clean-all: clean clean-image

# GDB 디버깅 모드로 실행
debug:
    @echo "GDB 디버깅 모드로 xv6를 실행합니다."
    @echo "다른 터미널에서 'just connect-gdb' 명령을 실행하세요."
    docker run --platform=linux/amd64 --rm -it --privileged -p 26000:26000 -v $(pwd):/host -v $(pwd)/{{XV6_PATH}}:/workspace/xv6-public {{IMAGE_NAME}} bash -c "cd /workspace/xv6-public && make qemu-gdb"

# GDB 클라이언트 연결
connect-gdb:
    docker run --platform=linux/amd64 --rm -it -v $(pwd):/host -v $(pwd)/{{XV6_PATH}}:/workspace/xv6-public {{IMAGE_NAME}} bash -c "cd /workspace/xv6-public && gdb"

# 도움말
help:
    @echo "사용 가능한 명령어들:"
    @echo "  build-image     : Docker 이미지 빌드"
    @echo "  build-xv6       : xv6 소스 빌드"
    @echo "  run-xv6         : xv6 실행 (GUI 모드)"
    @echo "  run-xv6-nox     : xv6 실행 (텍스트 모드)"
    @echo "  build-and-run   : 빌드 후 바로 실행"
    @echo "  shell           : Docker 컨테이너 쉘 접속"
    @echo "  clean           : 빌드 파일 정리"
    @echo "  clean-image     : Docker 이미지 제거"
    @echo "  clean-all       : 전체 정리"
    @echo "  debug           : GDB 디버깅 모드"
    @echo "  connect-gdb     : GDB 클라이언트 연결"
    @echo "  help            : 이 도움말 표시"
    @echo ""
    @echo "빠른 시작:"
    @echo "  1. just build-image"
    @echo "  2. just build-and-run"

# 기본 명령 (help 표시)
default: help