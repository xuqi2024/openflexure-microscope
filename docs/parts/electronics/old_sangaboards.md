
# Old versions of the Sangaboard

>i A [version 0.5], based on the RP2040 from the Raspberry Pi Pico, is now available and is recommended for this version of the microscope.
>i If you can't get hold of version 0.5, the best option is the [workaround] using easily-available microcontroller boards. This avoids
>i soldering and custom electronics boards.

The motor electronics in the microscope have undergone a number of revisions. The first two versions of the board were equivalent to the [workaround] using an Arduino Nano, mounted on a PCB for neatness. There is also [version 0.3], a surface-mount design with an integrated ATMEGA32 with Arduino-style programming. The first HAT-shaped board, [version 0.4], also based on ATMEGA32, has been problematic and is **not recommended**. It was intended to simplify wiring and power management, but only a few working boards were made due to problems specifying component values.

The Sangaboard uses surface mount components and custom boards, this makes it hard to solder your own. If you do make a Sangaboard v0.3 or v0.4, you will first need to burn the [custom bootloader].

All versions of the board should be able to use the same firmware. See the [version 0.5] page for details. There exists an older version of the firmware as a [Sangaboard arduino sketch] but this is no longer maintained. 

[custom bootloader]: https://gitlab.com/bath_open_instrumentation_group/sangaboard/blob/master/Bootloader/README.md
[Sangaboard arduino sketch]: https://gitlab.com/bath_open_instrumentation_group/sangaboard/-/tree/master/arduino_code
[version 0.5]: ./sangaboard.md
[version 0.3]: https://kitspace.org/boards/gitlab.com/bath_open_instrumentation_group/sangaboard/sangaboard_v0.3/
[version 0.4]: https://kitspace.org/boards/gitlab.com/bath_open_instrumentation_group/sangaboard/sangaboard_v0.4/
[workaround]: ../../workaround_motor_electronics/workaround_motor_electronics.md


