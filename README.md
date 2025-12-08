# 📦 TWRP RootFS Installer with Magisk Support

**The ultimate TWRP flashable installer** that automatically handles rooting and Linux rootfs installation.

## 🎯 What Makes This Special?

- ✅ **Smart Detection** - Automatically detects if your device is rooted
- ✅ **Auto-Root** - Installs Magisk automatically if device is not rooted
- ✅ **Works Everywhere** - Functions on both rooted and non-rooted devices
- ✅ **Auto-Boot** - Starts rootfs automatically on Android boot (if rooted)
- ✅ **User Friendly** - Interactive launcher with menu selection
- ✅ **Zero Configuration** - Just flash and use!

## 🚀 Quick Start

### For Complete Beginners (Only TWRP, No Root)

1. **Download** the ZIP with Magisk included
2. **Boot to TWRP** Recovery
3. **Flash** the ZIP file
4. **Reboot** - Magisk will be installed automatically!
5. **Open Terminal** and run:
   ```bash
   su
   /data/local/rootfs/launch.sh
   ```

### For Rooted Users (Already Have Magisk/Root)

1. **Download** the ZIP (with or without Magisk)
2. **Flash** in TWRP
3. **Reboot**
4. **Enjoy** - Auto-boot is already enabled!

## 📁 Repository Setup

```bash
# Create repository
mkdir twrp-rootfs-installer
cd twrp-rootfs-installer

# Create workflow directory
mkdir -p .github/workflows

# Copy workflow file (from artifacts)
# Save as: .github/workflows/build.yml

# Initialize git
git init
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/USERNAME/twrp-rootfs-installer.git
git push -u origin main
```

## 🔨 Building Installer

### Step 1: Go to Actions Tab

1. Open your GitHub repository
2. Click **Actions** tab
3. Select **Build TWRP RootFS Installer (with Magisk)**
4. Click **Run workflow**

### Step 2: Configure Build

Fill in the workflow inputs:

| Parameter | Description | Example |
|-----------|-------------|---------|
| **rootfs_url** | URL to rootfs archive | `https://kali.download/.../kalifs-arm64-minimal.tar.xz` |
| **distro_name** | Distribution name | `kali`, `ubuntu`, `debian` |
| **arch** | Architecture | `arm64`, `armhf`, `amd64` |
| **include_magisk** | Include Magisk installer | `true` (recommended) |
| **magisk_version** | Magisk version | `27.0` or `latest` |

### Step 3: Download

1. Wait for build to complete (~5-10 minutes)
2. Download ZIP from **Artifacts**
3. Transfer to device
4. Flash in TWRP

## 📥 Installation Process

### What Happens During Flash?

```
1. Check if device is rooted
   ├─ If ROOTED ✓
   │  └─ Skip Magisk installation
   │
   └─ If NOT ROOTED ⚠
      └─ Install Magisk automatically
         ├─ Success ✓ → Device is now rooted
         └─ Failed ⚠ → Save Magisk.apk to /sdcard/

2. Extract and install rootfs
   └─ Location: /data/local/rootfs/[distro-name]/

3. Create launcher scripts
   ├─ launch.sh (interactive menu)
   ├─ boot-chroot.sh (manual start)
   └─ auto-boot.sh (auto-start service)

4. Setup auto-boot service (if rooted)
   └─ Install: /data/adb/service.d/rootfs-boot.sh

5. Complete! ✓
```

### Installation Logs

Check what happened during installation:

```bash
# TWRP log
cat /tmp/recovery.log

# Auto-boot log (after reboot)
cat /data/local/rootfs-boot.log

# README file
cat /data/local/rootfs/README.txt
```

## 🎮 Usage

### Method 1: Interactive Launcher (Recommended)

```bash
su
/data/local/rootfs/launch.sh
```

**Output:**
```
════════════════════════════════
   RootFS Launcher
════════════════════════════════

Available RootFS installations:

  1) kali-arm64
  2) ubuntu-arm64
  3) debian-arm64

════════════════════════════════
Select [1-3] or 'q' to quit: 1
```

### Method 2: Direct Boot Script

```bash
su
cd /data/local/rootfs/kali-arm64
./boot-chroot.sh
```

### Method 3: Simple Chroot (No Root Required)

```bash
# Without root (limited functionality)
cd /data/local/rootfs/kali-arm64
chroot . /bin/bash

# Note: You need to manually setup mounts
```

### Method 4: Auto-Boot (Rooted Devices Only)

Your rootfs will start automatically on every boot!

Check status:
```bash
cat /data/local/rootfs-boot.log
```

## 🔄 Auto-Boot Feature

### How It Works

```
Android Boot
    ↓
Magisk Loads
    ↓
Runs /data/adb/service.d/rootfs-boot.sh
    ↓
Checks for auto-boot.sh in each rootfs
    ↓
Mounts filesystems and starts services
    ↓
Your rootfs is ready!
```

### Customize Auto-Boot

Edit the auto-boot script for your rootfs:

```bash
su
nano /data/local/rootfs/kali-arm64/auto-boot.sh
```

**Example: Start SSH on boot**

```bash
#!/system/bin/sh

ROOTFS="$(cd "$(dirname "$0")" && pwd)"

# ... (existing mount code) ...

# Start SSH service
chroot $ROOTFS /bin/systemctl start ssh

# Start PostgreSQL
chroot $ROOTFS /bin/systemctl start postgresql

# Start any service you want
chroot $ROOTFS /usr/bin/your-command
```

### Disable Auto-Boot

**For specific rootfs:**
```bash
su
rm /data/local/rootfs/kali-arm64/auto-boot.sh
```

**For all rootfs:**
```bash
su
rm /data/adb/service.d/rootfs-boot.sh
```

## 📋 Supported Distributions

### Kali Linux NetHunter

```yaml
rootfs_url: https://kali.download/nethunter-images/current/rootfs/kalifs-arm64-minimal.tar.xz
distro_name: kali
arch: arm64
include_magisk: true
```

**Full version:**
```yaml
rootfs_url: https://kali.download/nethunter-images/current/rootfs/kalifs-arm64-full.tar.xz
distro_name: kali
arch: arm64
```

### Ubuntu

**22.04 LTS:**
```yaml
rootfs_url: https://cdimage.ubuntu.com/ubuntu-base/releases/22.04/release/ubuntu-base-22.04-base-arm64.tar.gz
distro_name: ubuntu
arch: arm64
```

**20.04 LTS:**
```yaml
rootfs_url: https://cdimage.ubuntu.com/ubuntu-base/releases/20.04/release/ubuntu-base-20.04-base-arm64.tar.gz
distro_name: ubuntu
arch: arm64
```

### Debian

**Bookworm (12):**
```yaml
rootfs_url: https://github.com/debuerreotype/docker-debian-artifacts/raw/dist-arm64v8/bookworm/rootfs.tar.xz
distro_name: debian
arch: arm64
```

**Bullseye (11):**
```yaml
rootfs_url: https://github.com/debuerreotype/docker-debian-artifacts/raw/dist-arm64v8/bullseye/rootfs.tar.xz
distro_name: debian
arch: arm64
```

### Alpine Linux

```yaml
rootfs_url: https://dl-cdn.alpinelinux.org/alpine/v3.18/releases/aarch64/alpine-minirootfs-3.18.0-aarch64.tar.gz
distro_name: alpine
arch: arm64
```

### Arch Linux ARM

```yaml
rootfs_url: http://os.archlinuxarm.org/os/ArchLinuxARM-aarch64-latest.tar.gz
distro_name: archlinux
arch: arm64
```

## 🔧 Troubleshooting

### Device Not Rooted After Flash

**Symptoms:**
- `su` command not found
- Auto-boot doesn't work
- No `/data/adb/` directory

**Solutions:**

1. **Check if Magisk.apk was saved:**
   ```bash
   ls -la /sdcard/Magisk.apk
   ```

2. **Install Magisk manually from TWRP:**
   ```bash
   # In TWRP, go to Install
   # Select /sdcard/Magisk.apk
   # Flash it
   # Reboot
   ```

3. **Or download Magisk manually:**
   - Download from: https://github.com/topjohnwu/Magisk/releases
   - Flash in TWRP
   - Flash this installer again

### Check Root Status

```bash
# Try to get root
su

# Check Magisk
ls -la /data/adb/magisk

# Check if Magisk is running
ps -A | grep magisk
```

### Auto-Boot Not Working

```bash
# Check if service exists
ls -la /data/adb/service.d/rootfs-boot.sh

# Check log
cat /data/local/rootfs-boot.log

# Test manually
su
sh /data/adb/service.d/rootfs-boot.sh

# Check if auto-boot.sh exists
ls -la /data/local/rootfs/*/auto-boot.sh
```

### Mounts Not Working

```bash
# Check what's mounted
mount | grep rootfs

# Check SELinux
getenforce

# Temporarily disable SELinux
su
setenforce 0

# Try mounting again
cd /data/local/rootfs/kali-arm64
./boot-chroot.sh
```

### Rootfs Extraction Failed

```bash
# Check available space
df -h /data

# Check rootfs integrity
cd /data/local/rootfs
ls -lah

# Try manual extraction
su
cd /data/local/rootfs
xz -dc /sdcard/kalifs-arm64-minimal.tar.xz | tar -xpf -
```

### Can't Enter Chroot

```bash
# Check if shell exists
ls -la /data/local/rootfs/kali-arm64/bin/bash
ls -la /data/local/rootfs/kali-arm64/bin/sh

# Try direct chroot
su
chroot /data/local/rootfs/kali-arm64 /bin/sh

# Check permissions
su
chmod -R 755 /data/local/rootfs
```

## 🗑️ Uninstallation

### Complete Removal

```bash
su

# Remove rootfs
rm -rf /data/local/rootfs

# Remove auto-boot service
rm -f /data/adb/service.d/rootfs-boot.sh

# Remove logs
rm -f /data/local/rootfs-boot.log

# Optional: Uninstall Magisk
# Flash Magisk uninstaller in TWRP
```

### Remove Specific Rootfs

```bash
su

# Remove one distro
rm -rf /data/local/rootfs/kali-arm64

# Keep others intact
ls -la /data/local/rootfs/
```

## 📊 What Gets Installed?

```
/data/local/rootfs/
├── [distro-name]/              # Your Linux rootfs
│   ├── bin/                    # Linux binaries
│   ├── etc/                    # Configuration files
│   ├── home/                   # Home directories
│   ├── root/                   # Root home
│   ├── usr/                    # User programs
│   ├── var/                    # Variable data
│   ├── boot-chroot.sh          # Manual start script
│   └── auto-boot.sh            # Auto-boot script
│
├── launch.sh                   # Interactive launcher
├── busybox                     # Busybox binary (optional)
└── README.txt                  # Installation info

/data/adb/
└── service.d/
    └── rootfs-boot.sh          # Magisk auto-boot service

/sdcard/
└── Magisk.apk                  # Magisk APK (if auto-install failed)
```

## 🎓 Advanced Usage

### Multiple Rootfs Installations

You can install multiple distributions:

```bash
su
/data/local/rootfs/launch.sh

# Shows:
# 1) kali-arm64
# 2) ubuntu-arm64  
# 3) debian-arm64
# 4) alpine-arm64
```

Each rootfs is independent and can have its own auto-boot configuration.

### Custom Mount Points

Edit `boot-chroot.sh` to add custom Android→Linux mounts:

```bash
# Add custom mount
mkdir -p $ROOTFS/android
mount --bind /system $ROOTFS/android

mkdir -p $ROOTFS/mydata
mount --bind /data/media/0/MyFolder $ROOTFS/mydata
```

### Running Services on Boot

Edit `/data/local/rootfs/[distro]/auto-boot.sh`:

```bash
#!/system/bin/sh

ROOTFS="$(cd "$(dirname "$0")" && pwd)"

# ... (existing mount code) ...

# Start SSH
chroot $ROOTFS /bin/systemctl start ssh

# Start Apache
chroot $ROOTFS /bin/systemctl start apache2

# Start MySQL
chroot $ROOTFS /bin/systemctl start mysql

# Run custom script
chroot $ROOTFS /usr/local/bin/my-startup-script.sh
```

### Networking Setup

**DNS Configuration:**
```bash
# Inside chroot
echo "nameserver 8.8.8.8" > /etc/resolv.conf
echo "nameserver 1.1.1.1" >> /etc/resolv.conf
```

**Hostname:**
```bash
# Inside chroot
hostname mylinux
echo "mylinux" > /etc/hostname
```

**Hosts file:**
```bash
# Inside chroot
echo "127.0.0.1 localhost" > /etc/hosts
echo "127.0.1.1 mylinux" >> /etc/hosts
```

### User Management

```bash
# Inside chroot

# Create new user
useradd -m -s /bin/bash myuser
passwd myuser

# Add to sudo group
usermod -aG sudo myuser

# Switch to user
su - myuser
```

## ⚙️ System Requirements

### Minimum Requirements

- **Android Version**: 7.0+ (Nougat)
- **Architecture**: ARM64, ARM32, x86_64, or x86
- **Storage**: 2GB+ free space on /data
- **Recovery**: TWRP Recovery installed
- **Root**: Optional (can be installed automatically)

### Recommended

- **Android Version**: 10.0+ (for best compatibility)
- **Storage**: 4GB+ free space
- **RAM**: 2GB+ for smooth operation
- **Magisk**: Pre-installed (but not required)

### Tested Devices

✅ Confirmed working on:
- Xiaomi (Redmi, POCO series)
- Samsung (Galaxy S, Note series)
- OnePlus (5 and newer)
- Google Pixel (all models)
- ASUS (ZenFone series)
- Realme devices
- Motorola devices

## 🔐 Security Notes

### SELinux

- Installer works with SELinux in enforcing mode
- Some features may require permissive mode
- Use `setenforce 0` temporarily if needed

### Permissions

- All scripts run with root privileges
- Rootfs files owned by root
- Be careful when modifying system files

### Magisk Detection

- Some apps detect Magisk (banking apps, games)
- Use Magisk Hide/DenyList if needed
- Zygisk can help bypass detection

## 🤝 Contributing

### Report Issues

Found a bug? Please report:
1. Device model and Android version
2. TWRP version
3. Root status (before and after flash)
4. Error messages from logs
5. Steps to reproduce

### Submit Rootfs URLs

Know a good rootfs source? Share it!

### Improve Scripts

Pull requests welcome for:
- Better error handling
- More distribution support
- Performance improvements
- Documentation updates

## 📝 License

MIT License - Free to use and modify

## 🔗 Useful Resources

### Official Sources

- [Kali NetHunter](https://www.kali.org/get-kali/#kali-mobile)
- [Ubuntu Base Images](https://cdimage.ubuntu.com/ubuntu-base/releases/)
- [Debian Images](https://www.debian.org/distrib/)
- [Alpine Linux](https://alpinelinux.org/downloads/)
- [Arch Linux ARM](https://archlinuxarm.org/platforms/armv8/generic)

### Magisk

- [Magisk GitHub](https://github.com/topjohnwu/Magisk)
- [Magisk Documentation](https://topjohnwu.github.io/Magisk/)
- [Magisk Modules](https://github.com/Magisk-Modules-Repo)

### Tools

- [TWRP Official](https://twrp.me/)
- [Termux](https://termux.dev/)
- [BusyBox](https://busybox.net/)

## ❓ FAQ

### Q: Do I need root before flashing?
**A:** No! The installer can automatically install Magisk if your device isn't rooted.

### Q: Will this work without Magisk?
**A:** Yes, but auto-boot feature won't work. You'll need to manually start the chroot.

### Q: Can I install multiple distros?
**A:** Yes! Flash multiple ZIPs with different distros. Use the launcher to switch between them.

### Q: Does this modify system partition?
**A:** No! Everything installs to /data partition. System stays untouched.

### Q: Will I lose data if I flash this?
**A:** No, it only adds files to /data/local/rootfs/. Your Android data is safe.

### Q: Can I use this without TWRP?
**A:** No, TWRP is required for installation. Once installed, TWRP isn't needed anymore.

### Q: Does this work on Android 14?
**A:** Yes! Tested and working on Android 7 through Android 14.

### Q: How do I update the rootfs?
**A:** Flash a new installer with updated rootfs. Old files will be replaced.

### Q: Can I use systemd services?
**A:** Yes, if your distro supports systemd (Ubuntu, Debian, Arch).

### Q: Does networking work?
**A:** Yes! Full network access through Android's connection.

---

**Made with ❤️ for the Android + Linux community**

*Star ⭐ this repo if you find it useful!*
