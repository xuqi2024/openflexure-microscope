

# About the microscope

The OpenFlexure microscope is a customisable optical microscope, using either very cheap webcam optics or lab quality, RMS threaded microscope objectives.  It uses an inverted geometry, and has a high quality mechanical stage which can be motorised using low cost geared stepper motors.


![An assembled OpenFlexure Microscope, courtesy of GOSH 2018](./images/microscope_gosh.jpg)

Academic papers describing the microscope are available open-access from [Biomedical Optics Express](https://doi.org/10.1364/BOE.385729) and [Review of Scientific Instruments](http://dx.doi.org/10.1063/1.4941068) and you can read various [media articles](https://github.com/rwb27/openflexure_microscope/wiki/Media-Articles) about it for a more user-friendly introduction.

Optomechanics is a crucial part of any microscope; when working at high magnification, it is absolutely crucial to keep the sample steady and to be able to bring it into focus precisely.  Accurate motion control is extremely difficult using printed mechanical parts, as good linear motion typically requires tight tolerances and a smooth surface finish.  This design for a 3D printed microscope stage uses plastic flexures, meaning its motion is free from friction and vibration.  It achieves steps well below 100nm when driven with miniature stepper motors, and is stable to within a few microns over several days.

This design aims to minimise both the amount of post-print assembly required, and the number of non-printed parts required. This is partly to make it as easy as possible to print and partly to maximise stability. Most of the microscope (including all the parts with flexures) prints as a single piece.  The majority of the expense is in the Raspberry Pi and its camera module; the design requires only around 200g of plastic and a few nuts, bolts and other parts.  The optics module (containing the camera and lens) can be easily swapped out or modified, for example to change the magnification/resolution by using a microscope objective, or adding a filter cube for fluorescence.

## Acknowledgements
This design has largely come out of academic research projects from numerous funders including

* The [Engineering and Physical Sciences Research Council](http://epsrc.ukri.org/)
* The Royal Society
* The Royal Commission for the Exhibition of 1851
* Queens' College, Cambridge

For [full information about funding please see our website]().

## Contributors

**Lead developer:**

* Richard Bowman  (University of Bath) - <r.w.bowman@bath.ac.uk>

Richard started this project while at the University of Cambridge, and continues to work on it at the University of Bath, UK.

Other core contributors

* Julian Stirling (University of Bath)
* Joel Collins (University of Bath)
* Kaspar Bumke (University of Bath)
* Grace Anyelwisye Mwakajinga (STICLab)
* Valerian Sanga (STICLab)
* Paul Nyakyi (STICLab)
* Qixing Meng (University of Bath)
* Joe Knapper (University of Bath)

For a more [complete contributor list please see our website.](https://openflexure.org/about/#funding)
