# Calculator sideload 설치 스크립트
# 사용법: 이 파일이 있는 폴더에서 관리자 권한 PowerShell 로 실행
#   1) 시작 메뉴에서 "Windows PowerShell" 우클릭 -> 관리자 권한으로 실행
#   2) cd <이 폴더 경로>
#   3) powershell -ExecutionPolicy Bypass -File .\Install.ps1
#
# 하는 일:
#   - 동봉된 자체 서명 인증서(.cer)를 신뢰할 수 있는 사용자(TrustedPeople) 저장소에 등록
#   - 계산기 패키지(.msixbundle/.msix)를 현재 사용자에게 설치
# Microsoft Store 계정/로그인, 개발자 모드 토글은 필요 없습니다.

#Requires -RunAsAdministrator
$ErrorActionPreference = "Stop"

$dir = Split-Path -Parent $MyInvocation.MyCommand.Definition

$cer = Get-ChildItem -Path $dir -Filter *.cer | Select-Object -First 1
if (-not $cer) { Write-Error "인증서(.cer) 파일을 찾을 수 없습니다. zip 을 통째로 풀었는지 확인하세요."; exit 1 }

$pkg = Get-ChildItem -Path $dir -Include *.msixbundle, *.msix -File -Recurse | Select-Object -First 1
if (-not $pkg) { Write-Error "패키지(.msixbundle/.msix) 파일을 찾을 수 없습니다."; exit 1 }

Write-Host "[1/2] 인증서 신뢰 등록: $($cer.Name)" -ForegroundColor Cyan
Import-Certificate -FilePath $cer.FullName -CertStoreLocation "Cert:\LocalMachine\TrustedPeople" | Out-Null

# 의존 프레임워크 패키지 수집 (Microsoft.UI.Xaml, VCLibs, .NET Native 등)
# 이게 없으면 0x80073CF3 (프레임워크를 찾을 수 없음) 으로 설치가 실패한다.
$depDir = Join-Path $dir "Dependencies"
$deps = @()
if (Test-Path $depDir) {
    $deps = Get-ChildItem -Path $depDir -Recurse -File |
            Where-Object { $_.Extension -in '.appx', '.msix', '.msixbundle' } |
            Select-Object -ExpandProperty FullName
}

if ($deps.Count -gt 0) {
    Write-Host "[2/2] 계산기 설치 (의존 프레임워크 $($deps.Count)개 포함): $($pkg.Name)" -ForegroundColor Cyan
    Add-AppxPackage -Path $pkg.FullName -DependencyPath $deps
} else {
    Write-Host "[2/2] 계산기 설치: $($pkg.Name)" -ForegroundColor Cyan
    Write-Host "경고: Dependencies 폴더가 없습니다. 프레임워크 누락 시 설치가 실패할 수 있습니다." -ForegroundColor Yellow
    Add-AppxPackage -Path $pkg.FullName
}

Write-Host ""
Write-Host "설치 완료. 시작 메뉴에서 'Calculator' 를 검색해 실행하세요." -ForegroundColor Green
