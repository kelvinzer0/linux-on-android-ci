#!/bin/sh
# Universal Linux on Android Embedded System - User Group Fixer
# Fixes network access for Linux chroot on Android kernel with CONFIG_ANDROID_PARANOID_NETWORK
# Compatible: Debian, Ubuntu, Kali, Arch, Alpine, OpenWrt, and all Linux distros

echo "WIB-7" > /tmp/TZ
cp /usr/share/zoneinfo/Asia/Jakarta /tmp/localtime
echo "nameserver 8.8.8.8" > /tmp/resolv.conf
echo "nameserver 1.1.1.1" >> /tmp/resolv.conf

# Backup
cp /etc/group /etc/group.bak 2>/dev/null
cp /etc/passwd /etc/passwd.bak 2>/dev/null

echo "=== Android Embedded System - Network Access Fixer ==="
echo ""

# ============================================
# ANDROID KERNEL GROUPS (MANDATORY)
# ============================================
# These are Android Application IDs (AID) groups
# Required by CONFIG_ANDROID_PARANOID_NETWORK kernel config

echo "Adding Android kernel groups..."

cat >> /etc/group << 'EOF'
aid_net_bt_admin:x:3001:
aid_net_bt:x:3002:
aid_inet:x:3003:root
aid_net_raw:x:3004:
aid_net_admin:x:3005:
aid_net_bw_stats:x:3006:
aid_net_bw_acct:x:3007:
aid_net_bt_stack:x:3008:
aid_graphics:x:1003:
EOF

echo "✓ Android kernel groups added"

# ============================================
# AUTO-DETECT AND FIX PACKAGE MANAGER USERS
# ============================================

echo ""
echo "Detecting package manager users..."

FIXED_USERS=""

# Debian/Ubuntu/Kali - user _apt
if grep -q "^_apt:" /etc/passwd; then
    echo "→ Found: _apt (Debian/Ubuntu/Kali APT)"
    
    # Add to groups
    sed -i 's/^aid_inet:x:3003:root$/aid_inet:x:3003:root,_apt/' /etc/group
    sed -i 's/^aid_net_raw:x:3004:$/aid_net_raw:x:3004:_apt/' /etc/group
    
    # Change primary group to 3003 (aid_inet)
    sed -i 's/^\(_apt:x:[0-9]*:\)[0-9]*/\13003/' /etc/passwd
    
    FIXED_USERS="$FIXED_USERS _apt"
fi

# Alpine - user nobody (apk uses nobody)
if [ -f /etc/alpine-release ] && grep -q "^nobody:" /etc/passwd; then
    echo "→ Found: nobody (Alpine APK)"
    
    sed -i 's/^aid_inet:x:3003:\(.*\)$/aid_inet:x:3003:\1,nobody/' /etc/group
    sed -i 's/^aid_net_raw:x:3004:\(.*\)$/aid_net_raw:x:3004:\1,nobody/' /etc/group
    
    FIXED_USERS="$FIXED_USERS nobody"
fi

# Arch - user alpm (pacman)
if grep -q "^alpm:" /etc/passwd; then
    echo "→ Found: alpm (Arch Pacman)"
    
    sed -i 's/^aid_inet:x:3003:\(.*\)$/aid_inet:x:3003:\1,alpm/' /etc/group
    sed -i 's/^aid_net_raw:x:3004:\(.*\)$/aid_net_raw:x:3004:\1,alpm/' /etc/group
    
    FIXED_USERS="$FIXED_USERS alpm"
fi

# OpenWrt - user network
if grep -q "^network:" /etc/passwd; then
    echo "→ Found: network (OpenWrt)"
    
    sed -i 's/^aid_inet:x:3003:\(.*\)$/aid_inet:x:3003:\1,network/' /etc/group
    sed -i 's/^aid_net_raw:x:3004:\(.*\)$/aid_net_raw:x:3004:\1,network/' /etc/group
    
    FIXED_USERS="$FIXED_USERS network"
fi

# Fedora/RHEL - check for dnf user or use nobody
if [ -f /etc/redhat-release ]; then
    echo "→ Detected: Fedora/RHEL"
    
    if grep -q "^nobody:" /etc/passwd; then
        sed -i 's/^aid_inet:x:3003:\(.*\)$/aid_inet:x:3003:\1,nobody/' /etc/group
        sed -i 's/^aid_net_raw:x:3004:\(.*\)$/aid_net_raw:x:3004:\1,nobody/' /etc/group
        FIXED_USERS="$FIXED_USERS nobody"
    fi
fi

# ============================================
# ADDITIONAL NETWORK USERS (OPTIONAL)
# ============================================

# Debian-transmission (BitTorrent client)
if grep -q "^debian-transmission:" /etc/passwd; then
    echo "→ Found: debian-transmission"
    sed -i 's/^aid_inet:x:3003:\(.*\)$/aid_inet:x:3003:\1,debian-transmission/' /etc/group
    sed -i 's/^aid_net_raw:x:3004:\(.*\)$/aid_net_raw:x:3004:\1,debian-transmission/' /etc/group
fi

# Debian-exim (mail server)
if grep -q "^Debian-exim:" /etc/passwd; then
    echo "→ Found: Debian-exim"
    sed -i 's/^aid_inet:x:3003:\(.*\)$/aid_inet:x:3003:\1,Debian-exim/' /etc/group
fi

# list user (Mailman)
if grep -q "^list:" /etc/passwd; then
    echo "→ Found: list (Mailman)"
    sed -i 's/^aid_inet:x:3003:\(.*\)$/aid_inet:x:3003:\1,list/' /etc/group
fi

# ============================================
# VERIFICATION & SUMMARY
# ============================================

echo ""
echo "=== Setup Complete ==="
echo ""
echo "Android kernel groups configured:"
grep "^aid_" /etc/group
echo ""

if [ -n "$FIXED_USERS" ]; then
    echo "✓ Network access granted to:$FIXED_USERS"
else
    echo "⚠ No package manager user detected"
    echo "  Only root will have network access"
fi

echo ""
echo "Backup files:"
echo "  /etc/group.bak"
echo "  /etc/passwd.bak"
echo ""
echo "To add more users to network groups:"
echo "  usermod -G 3003,3004 -a <username>"
echo ""
