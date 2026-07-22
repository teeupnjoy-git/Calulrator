# Custom Build (GitHub Actions -> 설치 가능한 MSIX)

이 저장소는 [microsoft/calculator](https://github.com/microsoft/calculator) 소스의 스냅샷에,
GitHub Actions 로 Windows 계산기를 빌드하여 **Microsoft Store 없이 설치 가능한 자체 서명 패키지**를
만들어 배포하는 설정을 추가한 것입니다.

## 동작 방식

1. `.github/workflows/build-msix.yml` 가 Windows 러너에서 `src/Calculator/Calculator.csproj` 를
   Release/x64 sideload 모드로 빌드하여 `.msixbundle` 을 생성합니다.
2. 매니페스트 Publisher(`CN=Microsoft Corporation, ...`) 와 일치하는 자체 서명 인증서를 즉석에서 만들어
   `signtool` 로 패키지에 서명합니다.
3. 서명된 패키지 + 공개 인증서(`.cer`) + 설치 스크립트(`packaging/` 의 파일들)를
   `Calculator-Windows-x64.zip` 으로 묶습니다.
4. 이 zip 을 workflow **artifact** 와 **GitHub Release** 양쪽으로 올립니다.

## 빌드 실행 방법

- GitHub 저장소 -> Actions 탭 -> "Build Calculator MSIX (sideload)" -> "Run workflow" (workflow_dispatch)
- 또는 `main` 에 push (워크플로우/packaging 파일 변경 시 자동 실행)

빌드가 끝나면 Releases 또는 Actions 실행 결과의 Artifacts 에서 `Calculator-Windows-x64.zip` 을
내려받아 설치하면 됩니다. 설치 방법은 zip 안의 `README-INSTALL.txt` 참고.

## 설치 (받는 사람)

zip 압축 해제 후, 관리자 권한 PowerShell 에서:

```powershell
powershell -ExecutionPolicy Bypass -File .\Install.ps1
```

## 참고 / 제약

- 현재 `microsoft/calculator` main 은 최신 툴체인(.NET 10, Visual Studio 2026, `.slnx`)을 사용합니다.
  GitHub 공개 Windows 러너(windows-2025)의 설치 구성에 따라 첫 빌드가 실패할 수 있으며,
  그 경우 Actions 로그와 `build-diagnostics` 아티팩트(build.binlog)를 보고 조정합니다.
- 자체 서명 방식이므로 받는 사람은 최초 1회 인증서를 신뢰해야 합니다. 인증서 신뢰 단계까지
  없애려면 유료 공개 코드서명 인증서가 필요합니다.
- 원본 라이선스: MIT (LICENSE 파일 참고).
