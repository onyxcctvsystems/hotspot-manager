# Debug script to check Gradle configuration
Write-Host "=== Checking Android project structure ==="
Write-Host "Current directory: $(Get-Location)"

Write-Host "`n=== Checking if app directory exists ==="
if (Test-Path "app") {
    Write-Host "✓ app directory exists"
    Write-Host "Contents of app directory:"
    Get-ChildItem "app" -Name
    
    Write-Host "`n=== Checking app/build.gradle ==="
    if (Test-Path "app/build.gradle") {
        Write-Host "✓ app/build.gradle exists"
        Write-Host "First 10 lines of app/build.gradle:"
        Get-Content "app/build.gradle" | Select-Object -First 10
    } else {
        Write-Host "✗ app/build.gradle missing"
    }
} else {
    Write-Host "✗ app directory missing"
}

Write-Host "`n=== Checking settings.gradle ==="
if (Test-Path "settings.gradle") {
    Write-Host "✓ settings.gradle exists"
    Write-Host "Contents of settings.gradle:"
    Get-Content "settings.gradle"
} else {
    Write-Host "✗ settings.gradle missing"
}

Write-Host "`n=== Checking Gradle wrapper ==="
if (Test-Path "gradlew") {
    Write-Host "✓ gradlew exists"
} else {
    Write-Host "✗ gradlew missing"
}

if (Test-Path "gradle/wrapper/gradle-wrapper.properties") {
    Write-Host "✓ gradle-wrapper.properties exists"
    Write-Host "Contents:"
    Get-Content "gradle/wrapper/gradle-wrapper.properties"
} else {
    Write-Host "✗ gradle-wrapper.properties missing"
}

Write-Host "`n=== Checking Java availability ==="
try {
    $javaVersion = java -version 2>&1
    Write-Host "✓ Java found: $javaVersion"
} catch {
    Write-Host "✗ Java not found in PATH"
}
