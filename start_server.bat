@echo off
REM ===================================================
REM  KSP AHNRFZI - Jalankan Server (klik 2x langsung tampil)
REM ===================================================
cd /d %~dp0

if not exist ".venv\Scripts\uvicorn.exe" (
  echo [ERROR] Virtual env tidak ditemukan di .venv
  echo Jalankan: python -m venv .venv ^&^& .venv\Scripts\pip install -r requirements.txt
  pause
  exit /b 1
)

echo [1/3] Cek database...
".venv\Scripts\python.exe" scripts\ensure_db.py
if errorlevel 1 (
  echo [ERROR] Seeding database gagal. Lihat pesan di atas.
  pause
  exit /b 1
)

REM Kalau server 8000 sudah jalan (mis. dari autostart), langsung buka browser saja
powershell -NoProfile -Command "try { $c=(Invoke-WebRequest -UseBasicParsing http://localhost:8000/api/v1/health -TimeoutSec 2).StatusCode; if($c -eq 200){ exit 0 } else { exit 1 } } catch { exit 1 }"
if %errorlevel%==0 (
  echo Server sudah jalan di http://localhost:8000 - membuka browser...
  start http://localhost:8000
  exit /b 0
)

echo [2/3] Menyiapkan browser otomatis (terbuka saat server siap)...
start "" powershell -NoProfile -WindowStyle Hidden -Command "$i=0; while($i -lt 60){ try { $c=(Invoke-WebRequest -UseBasicParsing http://localhost:8000/api/v1/health -TimeoutSec 2).StatusCode; if($c -eq 200){ Start-Process 'http://localhost:8000'; break } } catch {}; Start-Sleep 1; $i++ }"

echo [3/3] Menjalankan server di http://localhost:8000
echo (JANGAN tutup jendela ini selama aplikasi dipakai)
".venv\Scripts\uvicorn.exe" app.main:app --host 127.0.0.1 --port 8000
pause
