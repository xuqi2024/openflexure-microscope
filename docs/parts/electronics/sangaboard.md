# Sangaboard

[version 0.3]: https://kitspace.org/boards/gitlab.com/bath_open_instrumentation_group/sangaboard/sangaboard_v0.3/
[version 0.4]: https://kitspace.org/boards/gitlab.com/bath_open_instrumentation_group/sangaboard/sangaboard_v0.4/

We use a custom open source motor board called the Sangaboard. Currently we use [version 0.3], based on ATMEGA32 with Arduino-style programming. We are looking to move to a HAT version that is able to power the Pi. The first iteration [version 0.4], also based on  ATMEGA32, has been problematic and is not recommended. A version 0.5, based on the RP2050 from the Raspberry Pi Pico, is more promising.

The Sangaboard uses surface mount components and custom boards, this makes it hard to solder your own. If you do make a Sangaboard, you will first need to burn the [custom bootloader], before uploading the [Sangaboard arduino sketch]. We are looking into a way to sell the Sangaboard. 

[custom bootloader]: https://gitlab.com/bath_open_instrumentation_group/sangaboard/blob/master/Bootloader/README.md
[Sangaboard arduino sketch]: https://gitlab.com/bath_open_instrumentation_group/sangaboard/-/tree/master/arduino_code

If you cannot get a Sangaboard, you can [build your own Sangaboard-compatible motor controller](../../workaround_motor_electronics/workaround_motor_electronics.md)
