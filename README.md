# wsl-virtualbox
VBoxManage wrapper to use Virtualbox from WSL for Packer. This is very experimental and may cause issues. Use it in your own risk.

# Modern Updates
The original project was 4 years old. There were a few existing forks that made good fixes (@webhead404 and @3lixy). I took those and also added my own fix to `/tmp` path handling.

## Use Case
- You have a Windows host
- You want to use Packer to make Windows VMs
- You want to use Ansible to provision Windows VMs
- You can't support nested virtualization

As of April 2022, this has been tested to work with the following:
- Windows 10
- Ubuntu 20.04 on WSL 2
- Packer 1.8.0
- VirtualBox 6.1.32

## Installation
```bash
sudo su
mkdir -p /usr/local/bin
wget -O /usr/local/bin/VBoxManage.sh https://raw.githubusercontent.com/finarfin/wsl-virtualbox/master/VBoxManage.sh
chmod +x /usr/local/bin/VBoxManage.sh
ln -s /usr/local/bin/VBoxManage.sh /usr/bin/VBoxManage
exit
```

## Validate
```bash
VBoxManage --version
```

## Usage
No additional changes are required. You can use Packer's Virtualbox builders as usual.
