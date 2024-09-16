#!/bin/sh
#
# This file was automatically generated.
#
# It can be overwritten by nios2-flash-programmer-generate or nios2-flash-programmer-gui.
#

#
# Converting SOF File: C:\intelFPGA_lite\18.1\stop_exexution_flash0621\output_files\security.sof to: "..\flash/security_EPCS64_avl_mem.flash"
#
sof2flash --input="C:/intelFPGA_lite/18.1/stop_exexution_flash0621/output_files/security.sof" --output="../flash/security_EPCS64_avl_mem.flash" --offset=0x0 --verbose 

#
# Programming File: "..\flash/security_EPCS64_avl_mem.flash" To Device: EPCS64_avl_mem
#
nios2-flash-programmer "../flash/security_EPCS64_avl_mem.flash" --base=0x800000 --sidp=0x1009060 --id=0x0 --timestamp=1687340771 --device=1 --instance=0 '--cable=USB-Blaster on localhost [USB-0]' --program --verbose 

#
# Converting ELF File: C:\intelFPGA_lite\18.1\stop_exexution_flash0621\software\security_04\security_04.elf to: "..\flash/security_04_EPCS64_avl_mem.flash"
#
elf2flash --input="security_04.elf" --output="../flash/security_04_EPCS64_avl_mem.flash" --boot="$SOPC_KIT_NIOS2/components/altera_nios2/boot_loader_cfi.srec" --base=0x800000 --end=0x1000000 --reset=0x1004000 --verbose 

#
# Programming File: "..\flash/security_04_EPCS64_avl_mem.flash" To Device: EPCS64_avl_mem
#
nios2-flash-programmer "../flash/security_04_EPCS64_avl_mem.flash" --base=0x800000 --sidp=0x1009060 --id=0x0 --timestamp=1687340771 --device=1 --instance=0 '--cable=USB-Blaster on localhost [USB-0]' --program --verbose 

