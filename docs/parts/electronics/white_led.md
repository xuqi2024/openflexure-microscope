# White LED

## Details

*   **Supplier:** RS Electronics
*   **Supplier's part number:** 810-6705
*   **Manufacturer's part number:** C503D-WAN-CCBEB151

The white LED is for illumination. There are a number of criteria to keep in mind when buying an LED:

1. Shape. 5 mm, round, through hole LEDs fit in the condensor housing perfectly, but there's no reason you couldn't tweak STL files to use a 3mm LED.
2. Lens. Even with the PMMA lens in front of the LED in the condensor housing, a (water) clear lens causes the sample to be illuminated non-uniformly (i.e., cause [vignetting](https://en.wikipedia.org/wiki/Vignetting)). If possible, obtain a diffuse lens LED, or make the clear lens diffuse by following the instructions below.
3. Luminous intensity. An LED with an intensity around 65 cd provides enough light (even after making the lens diffuse). These are available with a voltage below 5 V, making it possible to use the Raspberry Pi as a power supply.
4. Wavelength. Consider using a "warm" white LED, as this means the wavelength range is closer to a filament bulb. This is a nice-to-have, not a hard requirement.

The part suggested above does not satisfy all the above criteria out-of-the-box: the lens is clear instead of diffuse and it is not a "warm" white. To make a diffuse lens out of a clear lens, see below.

### Making a (water) clear lens diffuse (skip if you bought an LED with a diffuse lens)

Requirements:
* Rotary tool with fine-grained sanding drum OR fine-grained sandpaper (P60 or above)

With a rotary tool and a fine-grained sanding drum, roughen up the top layer of the LED lens, taking off as little plastic as possible to not affect the fit in the condensor housing. Be careful to leave the bottom  ring of the LED intact, while ensuring all clear parts of the lens are made opaque. If you mind the dust on your lens, wash the plastic lens off with some acetone to remove the plastic dust. An unwashed lens provides better diffuse lighting than a washed lens.

Instead of a rotary tool with a fine-grained sanding drum, a piece of fine-grained sandpaper and some patience should be possible as well

Keep in mind that making the lens diffuse will lower the LED's luminous intensity a bit.
