# Why does the LED need a resistor?

LEDs are designed to be driven at constant current.  Simply connecting an LED to a 5v power supply is likely to result in too much current being drawn, potentially damagine either the power supply or the LED.  A resistor is a very basic way of driving the LED safely, but for low power LEDs such as the ones we use here, it is generally sufficient.  

## Calculating the right resistance

To calculate the right resistor value, we simply use Ohm's law, $`V=IR`$.  In this case, the voltage $`V`$ is 5v minus the operating voltage of your LED, typically 3.2v for a white LED, giving us 1.8v.  The operating current of the LED I then sets the required resistance: $`R=V/I`$.  For 30mA current, we therefore need $`R=1.8/0.03=60`$ Ohms.  We specify 150 Ohms to drive the LED below its maximum current rating - we don't need the extra brightness, and it saves on power and heat.

## Flicker and better drive electronics

Using a resistor only provides a constant current if the voltage is constant; it means any ripple in supply voltage will result in flickering of the LED.  It is also difficult to perform wire-to-wire soldering reliably.  For these reasons, future versions of the microscope will most likely use a small PCB to mount the LED and a constant current chip, which will more reliably provide a constant current.  This assembly will then be easier to mount, and have a proper connector on it, thus eliminating the wire-to-wire soldering used currently.