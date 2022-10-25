# Powering the LED from Raspberry Pi GPIO

The Sangaboard v4 provides an output to drive an LED, this uses a Darlington pair driver to allow it to be switched.  If a Sangaboard v4 is not available, you can also power the LED by wiring the LED-and-resistor assembly, or the illumination PCB, directly to ground and 5v on the Raspberry Pi GPIO pins.  The correct pins to use are shown in the image below.

!!**Warning** 
!!
!!if you are using a 5mm LED rather than the illumination PCB, you must use a resistor in series with the LED to avoid drawing too much current.  [i](info_pages/why_led_resistor.md) Wiring the LED with a missing or incorrect resistor may damage your Raspberry Pi.

![Connecting the LED to Raspberry Pi GPIO](diagrams/illumination_to_pi_wiring.png)
