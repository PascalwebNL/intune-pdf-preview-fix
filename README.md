# Intune PDF Preview Fix

## 📄 Overview
This repository contains a PowerShell script to fix **PDF preview issues** on Windows devices enrolled via **Microsoft Intune / Autopilot**.

The issue typically occurs when:
- Files originate from OneDrive / SharePoint / network locations
- Windows assigns the file to the **Internet Zone (Zone 3)**
- Security setting **180F** blocks the preview handler

---

## 🔧 What this script fixes

- ✅ Enables PDF preview in File Explorer
- ✅ Configures Microsoft Edge as PDF preview handler
- ✅ Fixes registry association for `.pdf`
- ✅ Adjusts Internet Zone setting (`180F`)
- ✅ Restarts Explorer to apply changes

---

## 📁 Script

See: `Fix-PdfPreview.ps1`

---

## 🚀 Deployment via Intune

### Option 1 – Platform Script

- Run as: **SYSTEM**
- 64-bit PowerShell: **Yes**

### Option 2 – Proactive Remediations (recommended)

- Detection: Check registry values
- Remediation: Run the script

---

## 🧠 Root Cause

Windows blocks preview handlers when files are marked as coming from an external zone (MOTW).

Registry key involved:
HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3

Value:

180F = 0

---

## ⚠️ Notes

- May be overridden by Group Policy or Intune configuration policies
- Test in controlled environment before deploying globally

---

## 📜 License

MIT License
