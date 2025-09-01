# XV6 Operating System

이 레포지토리는 MIT의 x86 [XV6](https://github.com/mit-pdos/xv6-public)을 Apple Silicon macos에서 편리하게 실행할 수 있도록 합니다.

## 빠른 시작

### 1. 초기 설정

처음 사용하는 경우 setup 스크립트를 실행하여 필요한 도구들을 설치하세요:

```bash
./setup.sh
```

이 스크립트는 다음 도구들을 확인하고 필요시 설치합니다:

- **Homebrew**: macOS 패키지 매니저
- **Just**: 명령어 러너 (make의 대안)
- **Docker**: 컨테이너 플랫폼

이후 `xv6-public` directory에 xv6 소스코드를 클론하면 됩니다.

### 2. 사용 가능한 명령어 보기

```bash
just
```

또는

```bash
just help
```

## 주요 명령어

### Docker 이미지 빌드

```bash
just build-image
```

첫 번째로 실행해야 하는 명령어입니다. XV6를 빌드하기 위한 Docker 환경을 준비합니다.

### XV6 빌드하기

```bash
just build-xv6
```

XV6 운영체제를 컴파일합니다.

### XV6 실행하기

```bash
just run-xv6
```

XV6를 QEMU 에뮬레이터에서 텍스트 모드로 실행합니다.

**XV6 사용법:**

- 부팅이 완료되면 `$` 프롬프트가 나타납니다
- 기본 명령어: `ls`, `cat`, `echo`, `mkdir`, `rm` 등
- 종료: `Ctrl+A` 그리고 `X`

### 컨테이너 쉘 접속

```bash
just shell
```

Docker 컨테이너에 bash 쉘로 직접 접속하여 수동으로 작업할 수 있습니다.

### 디버깅하기

```bash
just debug
```

GDB 디버거와 함께 XV6를 실행합니다.

별도 터미널에서 GDB 연결:

```bash
just connect-gdb
```

### 정리하기

```bash
just clean           # 빌드 파일만 정리
just clean-image     # Docker 이미지 제거
just clean-all       # 전체 정리 (빌드 파일 + Docker 이미지)
```

## 빠른 시작 가이드

완전히 처음 시작하는 경우:

```bash
# 1. 환경 설정
./setup.sh

# 2. Docker 이미지 빌드
just build-image

# 3. XV6 빌드
just build-xv6

# 4. XV6 실행
just run-xv6
```

## 트러블슈팅

### Docker가 실행되지 않는 경우

- Docker Desktop이 실행되고 있는지 확인하세요
- Applications 폴더에서 Docker를 찾아 실행하거나
- Spotlight 검색에서 "Docker"를 검색하여 실행하세요

### 권한 오류가 발생하는 경우

```bash
chmod +x setup.sh
```

### Just 명령어를 찾을 수 없는 경우

터미널을 다시 시작하거나 다음 명령어를 실행하세요:

```bash
source ~/.zprofile
```

### 빌드 오류가 발생하는 경우

```bash
# 빌드 파일 정리 후 다시 시도
just clean
just build-xv6

# 또는 Docker 이미지까지 다시 빌드
just clean-all
just build-image
just build-xv6
```

### M Series Mac에서 성능 문제

이 프로젝트는 Intel x86 아키텍처용으로 설계되어 있어 Apple Silicon Mac에서는 에뮬레이션으로 실행됩니다. 이는 정상적인 동작이며 성능이 다소 느릴 수 있습니다.
또한 Rosetta가 설치되어 있지 않으면 정상 동작하지 않을 수 있습니다.

## 프로젝트 구조

```
├── Dockerfile          # Docker 빌드 설정
├── justfile            # Just 명령어 정의
├── setup.sh            # 초기 설정 스크립트
├── README.md           # 이 파일
└── xv6-public/         # XV6 소스 코드
    ├── Makefile        # XV6 빌드 설정
    ├── kernel.ld       # 링커 스크립트
    ├── main.c          # 커널 메인
    ├── proc.c          # 프로세스 관리
    ├── syscall.c       # 시스템 콜
    └── ...             # 기타 XV6 소스 파일들
```

## 사용 가능한 모든 명령어

| 명령어                  | 설명                    |
| ----------------------- | ----------------------- |
| `just` 또는 `just help` | 도움말 표시             |
| `just build-image`      | Docker 이미지 빌드      |
| `just build-xv6`        | XV6 소스 빌드           |
| `just run-xv6`          | XV6 실행 (텍스트 모드)  |
| `just shell`            | Docker 컨테이너 쉘 접속 |
| `just clean`            | 빌드 파일 정리          |
| `just clean-image`      | Docker 이미지 제거      |
| `just clean-all`        | 전체 정리               |
| `just debug`            | GDB 디버깅 모드         |
| `just connect-gdb`      | GDB 클라이언트 연결     |

## 더 자세한 정보

- [XV6 공식 문서](https://pdos.csail.mit.edu/6.828/2018/xv6.html)
- [XV6 소스코드 북](https://pdos.csail.mit.edu/6.828/2018/xv6/book-rev11.pdf)
- [Just 공식 문서](https://github.com/casey/just)

## 문제 해결 순서

문제가 발생하면 다음 순서로 해결해보세요:

1. Docker Desktop이 실행 중인지 확인
2. `just clean` 으로 빌드 파일 정리 후 다시 빌드
3. `just clean-all` 로 전체 정리 후 처음부터 다시 시작
4. 터미널 재시작 후 다시 시도
5. Docker 컨테이너에 직접 접속하여 문제 확인: `just shell`
