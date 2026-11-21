# Deliverable III demo copy (frozen snapshot of fyp-kaam on 15 Nov 2026).
# Right-click > "Run with PowerShell", or run .\START_DEMO.ps1 in PowerShell from this folder.
# Then open http://127.0.0.1:8000 in a browser. Press Ctrl+C in this window to stop.
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $here
$env:SUMO_HOME = Join-Path $here ".venv\Lib\site-packages\sumo"   # use this copy's SUMO only
& (Join-Path $here ".venv\Scripts\python.exe") -m manzil.api
