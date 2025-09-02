FROM --platform=linux/amd64 ubuntu:22.04

# 환경 변수 설정
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Seoul

# 기본 패키지 업데이트 및 필수 도구 설치
RUN apt-get update && apt-get install -y \
    build-essential \
    gcc \
    make \
    gdb \
    qemu-system-i386 \
    qemu-system-x86 \
    git \
    vim \
    wget \
    curl \
    binutils \
    libc6-dev \
    gcc-multilib \
    g++-multilib \
    libc6-dev-i386 \
    tmux \
    screen \
    && rm -rf /var/lib/apt/lists/*

# 32비트 라이브러리 설치 (i386 아키텍처 지원)
RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y \
    libc6:i386 \
    libstdc++6:i386 \
    && rm -rf /var/lib/apt/lists/*

# 작업 디렉토리 설정
WORKDIR /workspace

# GDB 자동 로드 경로 설정
RUN mkdir -p /root/.config/gdb && touch /root/.config/gdb/gdbinit && echo "set auto-load safe-path /workspace" >> /root/.config/gdb/gdbinit

# 권한 설정
RUN chmod -R 755 /workspace

# QEMU 실행을 위한 환경 설정
ENV QEMU=qemu-system-i386

# 기본 명령어 설정
CMD ["/bin/bash"]