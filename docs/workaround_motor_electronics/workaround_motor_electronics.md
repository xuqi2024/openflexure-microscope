# Controlling motors without a Sangaboard

The official project uses the [Sangaboard motor controller](../parts/electronics/sangaboard.md), but this is currently difficult to get hold of. This guide tells you how to create your own motor controller that is compatible with the Sangaboard firmware, based on existing boards that are easy to obtain. This will allow you to drive the [28BYJ-48] stepper motors used for the microscope.  

[28BYJ-48]: ../parts/electronics.yml#28BYJ-48

{{BOM}}

* The alternative electronics use the same electronics drawer as the Sangaboard v4 and v5, so you should print this as described in the main instructions.
* [Print the additional holders for the boards](./print_board_holders.md){step}.
* [Wire up the electronics boards](./wire_up_boards.md){step}.
* [Mount the boards and upload the firmware](./mount_boards_and_upload_firmware.md){step}.
* Continue wiring up the microscope by connecting the motors, as described in the main instructions.