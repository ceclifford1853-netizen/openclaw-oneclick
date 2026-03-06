# OpenClaw One-Click Installer

**The only 2026 solution for a zero-error Windows installation of OpenClaw AI.**

## Overview

OpenClaw One-Click Installer automates the entire setup process for OpenClaw on Windows, eliminating common installation failures related to WSL2 mismatches, Node.js conflicts, and systemd configuration errors.

**Installation Time:** ~2 minutes  
**Supported Architectures:** x64 (64-bit) and x86 (32-bit)  
**Security:** ClawJacked Shield hardening enabled by default

---

## Key Features

### ✓ Automatic Dependency Management
- Downloads and installs Node.js 22 LTS for your system architecture
- Automatically detects x64 vs x86 and installs the correct version
- Refreshes system PATH for immediate npm access

### ✓ WSL2 with Systemd Support (x64 only)
- Enables Windows Subsystem for Linux 2 automatically
- Configures systemd for background daemon support
- Ensures OpenClaw daemon starts on system reboot

### ✓ ClawJacked Shield Security Hardening
- Binds gateway to localhost (127.0.0.1) by default
- Prevents unauthorized external access
- Configures Windows Firewall rules for local-only communication
- Implements 2026 security patches automatically

### ✓ One-Click Installation
- Requires Administrator privileges (enforced)
- Silent mode with progress indicators
- Automatic rollback on failure
- Detailed error logging for troubleshooting

### ✓ Universal Architecture Support
- **x64 (64-bit):** Full WSL2 + systemd support
- **x86 (32-bit):** Native Windows fallback (no WSL2)

---

## System Requirements

| Requirement | Specification |
|---|---|
| **OS** | Windows 10 (Build 19041+) or Windows 11 |
| **RAM** | 4 GB minimum (8 GB recommended) |
| **Disk Space** | 500 MB available |
| **Architecture** | x64 or x86 |
| **Privileges** | Administrator access required |
| **PowerShell** | 5.1 or higher |

---

## Installation

### Method 1: Download Installer (Recommended)

1. Download the appropriate installer:
   - **64-bit:** `OpenClaw_Setup_x64.exe` (recommended for modern systems)
   - **32-bit:** `OpenClaw_Setup_x86.exe` (legacy/compatibility)

2. Run the installer as Administrator
3. Follow the on-screen prompts
4. Installation completes in ~2 minutes

### Method 2: Manual PowerShell Installation

```powershell
# Run PowerShell as Administrator, then:
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
.\scripts\install.ps1
```

---

## What Gets Installed

### Node.js 22 LTS
- Latest stable Node.js runtime
- npm package manager
- Global npm packages support

### OpenClaw Core
- Latest OpenClaw package from npm registry
- Quickstart configuration
- Background daemon setup

### Security Configuration
- **ClawJacked Shield:** Gateway bound to 127.0.0.1
- **Firewall Rules:** Local-only communication enabled
- **Systemd (x64):** Background daemon with auto-restart
- **Security Patches:** 2026 security baseline applied

---

## ClawJacked Shield: Security Architecture

### What is ClawJacked?

ClawJacked is a theoretical attack vector where a malicious website could hijack your OpenClaw AI daemon through WebSocket hijacking or unauthorized remote access.

### How ClawJacked Shield Protects You

1. **Local-Only Binding:** Gateway listens only on `127.0.0.1:3000`
2. **Firewall Isolation:** Windows Firewall rules restrict external connections
3. **No Remote Access:** By default, only local applications can communicate with OpenClaw
4. **Security Baseline:** 2026 security patches applied automatically

### Verification

After installation, verify ClawJacked Shield is active:

```powershell
openclaw config get gateway.address
# Should return: 127.0.0.1
```

---

## Post-Installation Steps

### 1. Verify Installation
```powershell
openclaw doctor
```

### 2. Access OpenClaw
- Open your browser
- Navigate to: `http://localhost:3000`
- Complete the OpenClaw onboarding

### 3. Configure as Needed
```powershell
openclaw config set <key> <value>
```

### 4. Check Daemon Status
```powershell
openclaw status
```

---

## Troubleshooting

### Issue: "Administrator privileges required"
**Solution:** Right-click the installer and select "Run as Administrator"

### Issue: "Node.js installation failed"
**Solution:** 
- Ensure you have internet connectivity
- Check Windows Firewall isn't blocking downloads
- Try manual installation: `winget install OpenJS.NodeJS`

### Issue: "WSL2 not found" (x64 only)
**Solution:**
- Enable Windows Subsystem for Linux: `wsl --install`
- Restart your computer
- Re-run the installer

### Issue: "OpenClaw daemon won't start"
**Solution:**
- Check systemd is enabled (x64): `wsl -u root bash -c "systemctl status"`
- Review logs: `openclaw logs`
- Reinstall: Run installer again

### Issue: "Port 3000 already in use"
**Solution:**
- Find process using port 3000: `netstat -ano | findstr :3000`
- Kill process: `taskkill /PID <PID> /F`
- Restart OpenClaw daemon

---

## Architecture-Specific Notes

### x64 (64-bit) Systems
- Full WSL2 support with systemd
- Recommended for development
- Best performance and compatibility
- All features enabled

### x86 (32-bit) Systems
- Native Windows environment (no WSL2)
- Limited to Windows-native Node.js features
- Reduced performance expectations
- ClawJacked Shield still active

---

## Security Best Practices

1. **Keep Updated:** Regularly check for installer updates
2. **Local Access Only:** Don't expose port 3000 externally
3. **Firewall Rules:** Review Windows Firewall configuration
4. **Regular Audits:** Run `openclaw doctor` periodically
5. **Secure Credentials:** Store API keys in environment variables, not code

---

## Uninstallation

### Via Control Panel
1. Open Settings → Apps → Apps & features
2. Find "OpenClaw One-Click Installer"
3. Click Uninstall
4. Follow prompts

### Via PowerShell
```powershell
npm uninstall -g openclaw
```

---

## Support & Reporting Issues

- **GitHub Issues:** [Report bugs](https://github.com/ceclifford1853-netizen/openclaw-oneclick/issues)
- **Documentation:** [Full docs](https://github.com/ceclifford1853-netizen/openclaw-installer-landing-page)
- **Security Issues:** [Security policy](SECURITY.md)

---

## Version Information

- **Installer Version:** 1.0.0
- **Release Date:** March 6, 2026
- **Node.js Version:** 22.11.0 LTS
- **Security Baseline:** 2026.03.06
- **ClawJacked Shield:** v1.0 Active

---

## License

MIT License - See LICENSE file for details

---

## Disclaimer

This installer is provided as-is. While we've implemented comprehensive security measures including ClawJacked Shield, no software is 100% secure. Always follow security best practices and keep your system updated.

**Not affiliated with OpenClaw Core contributors.**

---

## Changelog

### Version 1.0.0 (2026-03-06)
- Initial release
- x64 and x86 architecture support
- ClawJacked Shield security hardening
- WSL2 with systemd support (x64)
- Automated Node.js 22 LTS installation
- One-click installation UI
- Comprehensive error handling and logging
