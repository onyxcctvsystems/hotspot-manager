Write-Host "=== Checking Android project structure ==="
Write-Host "Current directory: $(Get-Location)"

Write-Host "`n=== Checking if app directory exists ==="
if (Test-Path "app") {
    Write-Host "app directory exists"
    Get-ChildItem "app" -Name
} else {
    Write-Host "app directory missing"
}

Write-Host "`n=== Checking settings.gradle ==="
if (Test-Path "settings.gradle") {
    Write-Host "settings.gradle exists"
    Get-Content "settings.gradle"
} else {
    Write-Host "settings.gradle missing"
}

Write-Host "`n=== Checking Java ==="
try {
    java -version
    Write-Host "Java found"
} catch {
    Write-Host "Java not found in PATH"
}
