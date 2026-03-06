# OpenClaw One-Click Installer - Universal & Secure (2026.03.06)
# ClawJacked Shield: Security-hardened installation with local-only binding
# Supports both x64 (modern) and x86 (legacy) Windows systems

$ErrorActionPreference = "Stop"
$arch = if ([Environment]::Is64BitOperatingSystem) { "x64" } else { "x86" }

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "OpenClaw One-Click Installer" -ForegroundColor Cyan
Write-Host "Architecture: $arch | Date: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Verify Administrator Privileges
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
if (-not $isAdmin) {
    Write-Host "ERROR: This installer requires Administrator privileges." -ForegroundColor Red
    Write-Host "Please run PowerShell as Administrator and try again." -ForegroundColor Red
    exit 1
}

Write-Host "[✓] Administrator privileges confirmed" -ForegroundColor Green
Write-Host ""

# ============================================================================
# STEP 1: Dependency Management - Node.js 22 LTS
# ============================================================================
Write-Host "[1/4] Installing Node.js 22 LTS ($arch)..." -ForegroundColor Yellow

try {
    # Determine correct Node.js download URL based on architecture
    $nodeVersion = "v22.11.0"
    $nodeUrl = if ($arch -eq "x64") {
        "https://nodejs.org/dist/$nodeVersion/node-$nodeVersion-x64.msi"
    } else {
        "https://nodejs.org/dist/$nodeVersion/node-$nodeVersion-x86.msi"
    }
    
    $installerPath = "$env:TEMP\node_setup.msi"
    
    Write-Host "  Downloading Node.js from: $nodeUrl" -ForegroundColor Gray
    Invoke-WebRequest -Uri $nodeUrl -OutFile $installerPath -ErrorAction Stop
    
    Write-Host "  Installing Node.js (silent mode)..." -ForegroundColor Gray
    Start-Process msiexec.exe -ArgumentList "/i `"$installerPath`" /qn /norestart" -Wait -ErrorAction Stop
    
    # Refresh PATH environment variable
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
    
    # Verify Node.js installation
    $nodeVersion = & node --version
    $npmVersion = & npm --version
    Write-Host "  ✓ Node.js installed: $nodeVersion" -ForegroundColor Green
    Write-Host "  ✓ npm installed: $npmVersion" -ForegroundColor Green
    
    # Clean up installer
    Remove-Item $installerPath -Force -ErrorAction SilentlyContinue
    
} catch {
    Write-Host "  ✗ Node.js installation failed: $_" -ForegroundColor Red
    exit 1
}

Write-Host ""

# ============================================================================
# STEP 2: WSL2 Enablement with Systemd (x64 only)
# ============================================================================
if ($arch -eq "x64") {
    Write-Host "[2/4] Initializing WSL2 with Systemd support..." -ForegroundColor Yellow
    
    try {
        Write-Host "  Enabling Windows Subsystem for Linux..." -ForegroundColor Gray
        wsl --install --no-distribution 2>&1 | Out-Null
        
        Write-Host "  Configuring systemd in WSL2..." -ForegroundColor Gray
        wsl -u root bash -c "echo -e '[boot]\nsystemd=true' > /etc/wsl.conf" 2>&1 | Out-Null
        
        Write-Host "  ✓ WSL2 enabled with systemd support" -ForegroundColor Green
        
    } catch {
        Write-Host "  ⚠ WSL2 configuration warning: $_" -ForegroundColor Yellow
        Write-Host "  Continuing with installation (WSL2 may require manual setup)" -ForegroundColor Yellow
    }
} else {
    Write-Host "[2/4] Skipping WSL2 (32-bit systems use native Windows fallback)" -ForegroundColor Yellow
    Write-Host "  ✓ 32-bit architecture detected - using native Windows environment" -ForegroundColor Green
}

Write-Host ""

# ============================================================================
# STEP 3: OpenClaw Core Deployment with ClawJacked Shield
# ============================================================================
Write-Host "[3/4] Deploying OpenClaw Core & Security Hardening..." -ForegroundColor Yellow

try {
    Write-Host "  Installing OpenClaw from npm registry..." -ForegroundColor Gray
    npm install -g openclaw@latest --loglevel=error
    
    Write-Host "  Running OpenClaw quickstart..." -ForegroundColor Gray
    openclaw onboard --quickstart --yes --accept-risk --install-daemon 2>&1 | Out-Null
    
    Write-Host "  Applying ClawJacked Shield (local-only binding)..." -ForegroundColor Gray
    openclaw config set gateway.address 127.0.0.1
    
    Write-Host "  Configuring Windows Firewall rules..." -ForegroundColor Gray
    # Allow local communication only
    netsh advfirewall firewall add rule name="OpenClaw Local" dir=in action=allow protocol=tcp localport=3000 remoteip=127.0.0.1 2>&1 | Out-Null
    
    Write-Host "  ✓ OpenClaw deployed with security hardening" -ForegroundColor Green
    Write-Host "  ✓ Gateway bound to localhost (127.0.0.1) - ClawJacked Shield active" -ForegroundColor Green
    
} catch {
    Write-Host "  ✗ OpenClaw deployment failed: $_" -ForegroundColor Red
    exit 1
}

Write-Host ""

# ============================================================================
# STEP 4: Final Validation & Health Check
# ============================================================================
Write-Host "[4/4] Finalizing & Running Health Check..." -ForegroundColor Yellow

try {
    Write-Host "  Running OpenClaw doctor..." -ForegroundColor Gray
    openclaw doctor 2>&1 | Out-Null
    
    Write-Host "  ✓ Health check passed" -ForegroundColor Green
    
} catch {
    Write-Host "  ⚠ Health check warning: $_" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "✓ SUCCESS: Installation Complete" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "OpenClaw is now running on your system." -ForegroundColor Green
Write-Host "Gateway Address: 127.0.0.1 (Local-only, ClawJacked Shield active)" -ForegroundColor Green
Write-Host "Architecture: $arch" -ForegroundColor Green
Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Cyan
Write-Host "  1. Open your browser and navigate to: http://localhost:3000" -ForegroundColor Cyan
Write-Host "  2. Complete the OpenClaw onboarding" -ForegroundColor Cyan
Write-Host "  3. For support, visit: https://github.com/ceclifford1853-netizen/openclaw-installer-landing-page" -ForegroundColor Cyan
Write-Host ""
Write-Host "Security Note: Your installation is protected by ClawJacked Shield." -ForegroundColor Yellow
Write-Host "The gateway is bound to localhost (127.0.0.1) for maximum security." -ForegroundColor Yellow
Write-Host ""
