#!/bin/bash

debug=1
[ $debug -eq 1 ] && echo "$(date) ### Start VBoxManage ###" >> /tmp/VBoxManage.log
# Get path for WSL storage
wslroot=$(wslpath $(/mnt/c/Windows/System32/reg.exe query "HKCU\Software\Microsoft\Windows\CurrentVersion\Lxss" /s /v BasePath | awk 'BEGIN { FS = "[ \t]+" } ; /BasePath/{print $4}' | tr -d "[:cntrl:]"))
# [ $debug -eq 1 ] && echo "$(date) wslroot $wslroot" >> /tmp/VBoxManage.log

# Initialize defaults
is_next_path=0
args=()

for argument; do
  [ $debug -eq 1 ] && echo "$(date) Raw Arg $argument" >> /tmp/VBoxManage.log
  # If the current argument is --medium expect path of the medium in next argument
  if [ "$argument" == 'none' ]; then
	  is_next_path=0
  elif [ "$argument" = '--medium' ]; then
    is_next_path=1
  elif [ $is_next_path = 1 ] || [[ "$argument" == /mnt/c/* ]]; then
    # Convert WSL paths to Windows path
    argument=$(wslpath -w "$argument")
    is_next_path=0
  fi

  [ $debug -eq 1 ] && echo "$(date) Processed Arg $argument" >> /tmp/VBoxManage.log
  args+=("\"$argument\"")
done

# Redirect to Windows VBoxManage and convert Windows paths back to WSL paths
[ $debug -eq 1 ] && echo "$(date) ${args[@]}" >> /tmp/VBoxManage.log
echo "${args[@]}" | xargs /mnt/c/Program\ Files/Oracle/VirtualBox/VBoxManage.exe | sed -r '/[A-Za-z]:\\.*$/{h; s/(.*)([A-Za-z]:\\.*)$/\2/; s/(.+)/wslpath "\1"/e; H; x; s/(([A-Za-z]:\\.*)\n(.+))/\3/ }'

# /[A-Za-z]:\\.*$/ # Find lines that end with Windows paths
#  { # For each line
#    h; # Copy to hold storage
#    s/(.*)([A-Za-z]:\\.*)$/\2/; #Remove everything except the path
#    s/(.+)/wslpath "\1"/e; #Convert the path to WSL path
#    H; # Append to the hold storage
#    x; # Swap pattern storage with hold storage
#       # Pattern storage have 2 lines now:
#       #   SAMPLE C:\Windows\Temp
        #   /mnt/c/Windows/Temp
#    s/(([A-Za-z]:\\.*)\n(.+))/\3/ # Replace Windows path in the first line with the WSL path in the second line
#  }
[ $debug -eq 1 ] && echo "$(date) ### End VBoxManage ###" >> /tmp/VBoxManage.log
