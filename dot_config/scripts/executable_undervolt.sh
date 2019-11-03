#!/usr/bin/env sh
/usr/sbin/wrmsr 0x150 0x80000011F1E00000  # cpu core  -110
/usr/sbin/wrmsr 0x150 0x80000211F1E00000  # cpu cache -110
/usr/sbin/wrmsr 0x150 0x80000111F4800000  # gpu core  -90
