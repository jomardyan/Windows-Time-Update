

# ⏰ Windows Time Update & Group Policy Tools
A set of advanced batch scripts for Windows administrators, featuring powerful time synchronization and Group Policy management utilities.

---


## 🚀 Features

### update_time_advanced.bat
- **Interactive Menu System:** Easy-to-use, guided interface
- **Quick Time Sync:** One-click time synchronization
- **Service Management:** Start, stop, and restart Windows Time service
- **NTP Server Configuration:** Choose from popular or custom NTP servers
- **Status Checking:** View current time service status and configuration
- **Force Sync:** Immediate, forced time sync
- **Multi-Server Sync:** Test and sync with multiple NTP servers
- **Time Difference Checking:** Compare local time with NTP servers
- **Configuration Reset:** Restore default Windows time settings
- **Error Handling:** Comprehensive error checking and troubleshooting tips

### PolicyUpdate.bat
- **Admin Privilege Check:** Ensures script is run as administrator
- **User & Computer Info:** Displays current user, computer, and date/time
- **Last Policy Update:** Shows last Group Policy update time (if available)
- **Logging:** All actions and results are logged to `PolicyUpdate.log`
- **Error Handling:** Detects and reports errors during update
- **Restart Option:** Offers to restart the computer if required for policy application
- **Clear Output:** User-friendly, color-coded messages and prompts

---

## 🌐 Popular NTP Servers

- `time.windows.com` (Windows default)
- `pool.ntp.org` (NTP Pool Project)
- `time.nist.gov` (NIST Time Server)
- `time.google.com` (Google Public NTP)

---


## 🛠️ Usage

### Time Update Script
1. **Run as Administrator:**  
   Right-click `update_time_advanced.bat` and select **Run as administrator** for full functionality.
2. **Follow the Interactive Menu:**  
   Select options as prompted for configuration and synchronization.
3. **Troubleshooting:**  
   The script provides detailed feedback and troubleshooting guidance for common issues.

### Group Policy Update Script
1. **Run as Administrator:**  
   Right-click `PolicyUpdate.bat` and select **Run as administrator**.
2. **Review Information:**  
   The script displays user/computer info, last update time, and logs all actions.
3. **Restart Option:**  
   Choose to restart the computer if prompted for full policy application.

---


## 🙏 Credits

Created by Hayk.

---

> _Feel free to contribute or suggest improvements!_
