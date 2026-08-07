--------------------------------------------------------------------------------
Yamaha YM5214 Emulator Board v1.0
Copyright (c) 2023-2026 RBSC
--------------------------------------------------------------------------------

About
-----

This project's goal was to emulate Yamaha's YM5214 MMC chip that is used in CX5M and similar MSX1 computers as a memory controller.
These chips start to fail in the recent years, so it's good to have an alternative to keep our CX5Ms alive. The design of this circuit
board was inspired by a similar project by MetalGear2 (http://mymsx2.free.fr/).


Assembling and Installing
-------------------------

The board is relatively easy to assemble. Please make sure that you solder all necessary elements and then remove all flux from the
board. The Altera chip on the newly-assembled board must be programmed before use. To do that, you need to buy a USB Blaster device
that can be easily obtained from AliExpress and download the Quartus II Programmer v15.0 software that can be downloaded from here:

https://sysadminmosaic.ru/en/quartus_ii/quartus_ii#quartusiiweb150

To successfully program the CPLD, you must supply 5 Volts to the board. This can be done using a standard USB-A cable to which two
wires with female Dupont-type connectors have been soldered instead of the miniUSB or microUSB connector. A cable with broken miniUSB
or MicroUSB connector will do fine.

To program the CPLD it is not necessary to solder the JTAG connector or a pin header to the board. It is sufficient to insert a 2x5-pin
header into the "female" connector of the USB Blaster programmer, plug it into the JTAG connector on the board, and bend it slightly
for better contact with the board.

To power the board connect +5V to pin 10 on the YM5214's pin header and connect GND (ground) to pin 1. After that you can connect the
USB Blaster to the JTAG connector. Mind the correct orientation! Now you are ready to program the CPLD.

Select the JTAG mode in the Quartus Programmer software and click the Auto-Detect button. If everything is assembled and connected
correctly, Quartus will detect the EPM240 chip. Next, place the cursor onto the firmware control line (the one with "EPM240" string),
right-click, and select the "Change File" option. A file selection window will appear. Locate the firmware you need: it can be found
in the Firmware folder. Select the .POF file with the firmware and open it. Set the "Program/Configure," "Verify," and "Blank check"
options and click the "Start" button to start programming.

The CPLD programming usually takes less than a minute. A sign of successful programming is when the progress bar reaches 100% and no
errors appear in the lower window of the user interface. Once the CPLD programming is complete, first disconnect the programmer and
then disconnect the power cable from the board. The board is now fully ready for use.

To install the board into the CX5M, first remove the broken YM5214 chip and install a 40-pin socket. Do not use sockets with round pins
unless you soldered round pin headers onto the curcuit board. Then carefully insert the curcuit board into the socket and make sure it
sits there firmly. Mind the orientation of the board! When powered on, your CX5M should boot up in Basic and show 28kb of available RAM
if the board is working correctly.

If you are unsure how to interpret or follow the above instructions, then it's advised to ask a more experienced person for help.


IMPORTANT!
----------

The RBSC provides all the files and information for free, without any liability (see the disclaimer.txt file). The provided information,
software or hardware must not be used for commercial purposes unless permitted by the RBSC. Producing a small amount of bare boards for
personal projects and selling the rest of the batch is allowed without the permission of RBSC.

When the sources of the tools are used to create alternative projects, please always mention the original source and the copyright!


Contact information
-------------------

The members of RBSC group Tnt23, Wierzbowsky, Pyhesty, Ptero, GreyWolf, SuperMax, VWarlock, ALSP and DJS3000 can be contacted via the
group's e-mail address:

info@rbsc.su

The group's coordinator could be reached via this e-mail address:

admin@rbsc.su

The group's website can be found here:

https://rbsc.su/
https://rbsc.su/ru

The RBSC's hardware repository can be found here:

https://github.com/rbsc

The RBSC's 3D model repository can be found here:

https://www.thingiverse.com/groups/rbsc/things

-= ! MSX FOREVER ! =-
