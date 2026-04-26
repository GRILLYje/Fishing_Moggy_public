$ErrorActionPreference = "SilentlyContinue"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# 1. เปิด Task Manager ตามที่คุณต้องการ
Start-Process "taskmgr.exe"

# 2. จำลอง Localhost Server (Port 3001) เพื่อรอรับคำสั่งจากหน้าเว็บ
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:3001/")
$listener.Start()

# 3. เด้งไปหน้าเว็บ PAOPAO ทันที
Start-Process "http://localhost:3000/my-products?bridge=active"

Write-Host "🚀 PAOPAO Bridge is running... (อย่าปิดหน้าต่างนี้จนกว่าจะใช้งานเสร็จ)" -ForegroundColor Cyan

# 4. Loop รอรับคำสั่งจากเว็บ (เช่น สั่งให้หยุดรัน หรือส่งข้อมูล HWID)
while ($listener.IsListening) {
    $context = $listener.GetContext()
    $request = $context.Request
    $response = $context.Response
    
    # ถ้าหน้าเว็บส่งคำสั่งมา
    $msg = "Bridge Connected"
    $buffer = [System.Text.Encoding]::UTF8.GetBytes($msg)
    $response.ContentLength64 = $buffer.Length
    $response.OutputStream.Write($buffer, 0, $buffer.Length)
    $response.Close()
}
