# 📘 Moltbot (Clawdbot) 윈도우 로컬 배포 & 트러블슈팅 인사이트
환경: Windows 11 / Node.js / PowerShell
에이전트: Moltbot (Antigravity Prime 페르소나, Clawdbot 기반)

1. 개요 (Overview)
이 문서는 로컬 AI 에이전트인 Moltbot을 윈도우 환경에 구축하면서 발생한 주요 기술적 이슈들과 해결 과정을 타임라인별로 정리한 보고서입니다. 동일한 환경에서 로컬 에이전트(Clawdbot 등)를 배포하려는 개발자들에게 실질적인 트러블슈팅 가이드를 제공하는 것을 목적으로 합니다.

2. 타임라인 및 핵심 이슈 (The Journey)
🕒 Phase 1: 텔레그램 연동의 미스터리 (The Silent Bot)

증상
에이전트 게이트웨이가 정상 구동되었고, curl을 통한 Outbound 통신은 성공함.

텔레그램 봇 API 토큰도 유효하지만, 사용자의 메시지를 전혀 수신하지 못함.

로그에 에러 메시지가 전혀 없음 (Silent Failure).

원인 분석
Long Polling 차단: 텔레그램 봇은 서버와 지속적인 연결(Long Polling)을 유지하며 메시지를 받습니다.

범인: Windows 방화벽 설정이 '공용 네트워크(Public)'로 되어 있었음.
윈도우의 '공용 네트워크' 프로필은 보안상 이렇게 지속적으로 들어오는(Inbound) 연결 요청이나 패킷을 엄격하게 차단합니다.

Review
Windows Firewall Public Profile

해결책 (Solution)
네트워크 프로필 변경: '공용' → '개인(Private)'으로 변경하는 것이 가장 확실합니다.
인바운드 규칙 추가: 공용 네트워크를 유지해야 한다면, 방화벽 설정(wf.msc)에서 node.exe에 대한 Inbound Allow 규칙을 수동으로 추가해야 합니다.

Review
Inbound Rule Wizard

🕒 Phase 2: 좀비 프로세스의 습격 (Port Conflict)

증상
설정 변경 후 게이트웨이 재시작(clawdbot gateway stop -> run) 시도.
Error: Port 18789 is already in use (PID: 24492).
stop 명령어를 쳤음에도 불구하고 기존 프로세스가 죽지 않고 포트를 점유 중.

인사이트
윈도우의 schtasks 기반 종료 명령이 가끔 Node.js 자식 프로세스까지 깔끔하게 정리하지 못할 때가 있습니다.
이를 방치하고 계속 실행하면 "Already Running" 에러의 무한 루프에 빠집니다.

해결책
PowerShell에서 강제 종료 명령 사용:
Stop-Process -Id <PID> -Force

# 또는
Stop-Process -Name node -Force

🕒 Phase 3: 유령 데스크탑 오류 (System Profile Desktop)

증상
게이트웨이 실행 중 간헐적으로 팝업 에러 발생.
Error: C:\WINDOWS\system32\config\systemprofile\Desktop is unavailable.

Review
System Profile Error

원인
Node.js나 일부 시스템 도구가 실행될 때 'Desktop' 폴더의 존재를 확인하는데, 윈도우 시스템 프로필(systemprofile) 디렉토리에는 기본적으로 이 폴더가 없습니다.

기능상 문제는 없으나 매우 거슬리는 에러 팝업을 유발합니다.

해결책

다음 두 경로에 Desktop이라는 이름의 빈 폴더를 직접 생성해주면 영구적으로 해결됩니다.
C:\Windows\System32\config\systemprofile\Desktop
C:\Windows\SysWOW64\config\systemprofile\Desktop

🕒 Phase 4: 설정의 미로 (Brave Search Config)

증상
웹 검색 기능을 켜기 위해 CLI 명령어를 사용했으나 스키마 유효성 검사 실패.
Error: web: Unrecognized keys: "provider", "brave".

인사이트
CLI 도구(clawdbot config set)는 중첩된 키 경로를 정확히 입력해야 합니다.
단순히 clawdbot config set web.provider ...라고 하면 루트 레벨에 web 객체를 만들지만, 실제 앱이 요구하는 경로는 tools.web.search.provider 였습니다.

Lesson: 설정이 막힐 때는 소스 코드(config/schema.js)를 확인하거나 doctor 명령어를 신뢰해야 합니다.

최종 적용 커맨드:
clawdbot config set tools.web.search.provider brave
clawdbot config set tools.web.search.apiKey <HIDDEN_KEY>

3. 결론 (Conclusion)
윈도우 환경에서 로컬 AI 에이전트를 운영하는 것은 강력하지만, 리눅스/맥 환경보다 조금 더 세심한 설정이 필요합니다.

방화벽은 항상 1순위 용의자입니다. (특히 공용 네트워크)

프로세스 정리(Kill) 명령어를 숙지하세요. (Stop-Process)

시스템 프로필 폴더 버그는 윈도우의 오래된 친구입니다. (폴더 생성으로 해결)

설정 경로는 정확해야 합니다. (Schema 확인 필수)

이 과정을 통해 Moltbot은 현재 텔레그램과 완벽하게 연동되었으며, 웹 검색 능력까지 갖춘 강력한 Antigravity Prime 페르소나로 거듭났습니다. 🚀
