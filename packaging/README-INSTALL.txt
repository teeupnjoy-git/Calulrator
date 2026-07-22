Windows 계산기 (custom sideload 설치) - 설치 안내
====================================================

이 zip 은 microsoft/calculator 를 직접 빌드해 자체 서명한 설치 패키지입니다.
Microsoft Store 계정이나 로그인 없이 설치할 수 있습니다.

포함 파일
---------
- Calculator_x64.msixbundle   : 계산기 앱 패키지 (x64)
- Calculator.cer              : 위 패키지에 서명한 자체 서명 공개 인증서
- Install.ps1                 : 인증서 신뢰 등록 + 앱 설치 자동 스크립트
- Uninstall.ps1               : 앱 제거 스크립트
- README-INSTALL.txt          : 이 파일

요구 사항
---------
- Windows 10/11 (x64)
- 관리자 권한 (인증서를 신뢰 저장소에 등록할 때 1회 필요)


설치 방법 A: 스크립트 (권장)
----------------------------
1. 이 zip 을 폴더에 통째로 압축 해제합니다.
2. 시작 메뉴에서 "Windows PowerShell" 을 우클릭 -> "관리자 권한으로 실행".
3. 압축 푼 폴더로 이동:
       cd "C:\경로\압축푼폴더"
4. 설치 실행:
       powershell -ExecutionPolicy Bypass -File .\Install.ps1
5. 시작 메뉴에서 "Calculator" 검색 후 실행.


설치 방법 B: 수동
------------------
1. Calculator.cer 더블클릭 -> "인증서 설치" -> 저장소 위치 "로컬 컴퓨터"
   -> "모든 인증서를 다음 저장소에 저장" -> 찾아보기 -> "신뢰할 수 있는 사람" 선택 -> 완료.
2. Calculator_x64.msixbundle 더블클릭 -> "설치".


제거
----
   powershell -ExecutionPolicy Bypass -File .\Uninstall.ps1


왜 인증서를 신뢰해야 하나요?
---------------------------
Windows 는 서명된 MSIX 만 설치를 허용합니다. 이 패키지는 공개 인증기관(CA)
유료 인증서 대신 빌드 시 생성한 자체 서명 인증서로 서명되어 있습니다.
그래서 최초 1회 이 인증서를 "신뢰할 수 있는 사람" 저장소에 등록해야 설치됩니다.
인증서 신뢰 단계조차 없이 설치되게 하려면 유료 공개 코드서명 인증서가 필요합니다.

이 인증서는 각 빌드마다 새로 생성되며, 배포물에는 개인키(pfx)가 포함되지
않고 공개 인증서(.cer)만 들어 있습니다.


원본/라이선스
-------------
원본: https://github.com/microsoft/calculator (MIT License)
