Write-Host "=== Environment Dump ==="
Write-Host "OS: $((Get-CimInstance Win32_OperatingSystem).Caption) $((Get-CimInstance Win32_OperatingSystem).OSArchitecture)"

$tools = @('cmake', 'ninja', 'git', 'python3', 'curl', 'tar')
foreach ($tool in $tools) {
    $path = Get-Command $tool -ErrorAction SilentlyContinue
    if ($path) {
        $ver = & $tool --version 2>&1 | Select-Object -First 1
        Write-Host "  ${tool}: $($path.Source)  ($ver)"
    } else {
        Write-Host "  ${tool}: NOT FOUND"
    }
}

$choco = Get-Command choco -ErrorAction SilentlyContinue
if ($choco) {
    $ver = & choco --version 2>&1 | Select-Object -First 1
    Write-Host "  choco: $($choco.Source)  ($ver)"
} else {
    Write-Host "  choco: NOT FOUND"
}

# Compiler
$compilers = @('cl', 'clang', 'g++')
foreach ($cc in $compilers) {
    $path = Get-Command $cc -ErrorAction SilentlyContinue
    if ($path) {
        $ver = & $cc --version 2>&1 | Select-Object -First 1
        Write-Host "  ${cc}: $($path.Source)  ($ver)"
        break
    }
}

Write-Host "=== End ==="
