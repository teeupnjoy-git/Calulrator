# Calculator sideload 제거 스크립트
# 사용법: 관리자 권한 PowerShell 에서
#   powershell -ExecutionPolicy Bypass -File .\Uninstall.ps1

$ErrorActionPreference = "Stop"

# 설치된 계산기(개발용 Identity) 제거
$app = Get-AppxPackage -Name "Microsoft.WindowsCalculator.Dev" -ErrorAction SilentlyContinue
if ($app) {
    Write-Host "계산기 제거: $($app.PackageFullName)" -ForegroundColor Cyan
    Remove-AppxPackage -Package $app.PackageFullName
    Write-Host "제거 완료." -ForegroundColor Green
} else {
    Write-Host "설치된 계산기(Microsoft.WindowsCalculator.Dev)를 찾지 못했습니다." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "참고: 신뢰 저장소에 등록한 인증서는 그대로 남습니다." -ForegroundColor DarkGray
Write-Host "완전히 지우려면 certlm.msc -> 신뢰할 수 있는 사람 -> 인증서 에서" -ForegroundColor DarkGray
Write-Host "'Microsoft Corporation' 자체 서명 항목을 수동 삭제하세요." -ForegroundColor DarkGray
