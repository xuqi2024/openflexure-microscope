# Sangaboard

[version 3]: https://kitspace.org/boards/gitlab.com/bath_open_instrumentation_group/sangaboard/sangaboard_v0.3/
[version 4]: https://kitspace.org/boards/gitlab.com/bath_open_instrumentation_group/sangaboard/sangaboard_v0.4/

We use a custom open source motor board called the Sangaboard. Currently we use [version 3], but we are looking to move to [version 4] in the near future. 
The Sangaboard uses surface mount components and custom boards, the makes it hard to solder your own. If you do make a Sangaboard, you will first need to burn the [custom bootloader], before uploading the [Sangaboard arduino sketch].

[custom bootloader]: https://gitlab.com/bath_open_instrumentation_group/sangaboard/blob/master/Bootloader/README.md
[Sangaboard arduino sketch]: https://gitlab.com/bath_open_instrumentation_group/sangaboard/-/tree/master/arduino_code

We are looking into a way to sell the Sangaboard. If you cannot get a Sangaboard, you can [build your own Sangaboard-compatible motor controller](../../workaround_motor_electronics.md)
