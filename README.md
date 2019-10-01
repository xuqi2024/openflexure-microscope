# OpenFlexure Microscope
The OpenFlexure Microscope is a  3D printable microscope, including a precise mechanical stage to move the sample and focus the optics.  There are many different options for the optics, ranging from a webcam lens to a 100x, oil immersion objective.

![An OpenFlexure Microscope in an incubator (courtesy Stephanie Reichelt and Dario Bressan at CRUK, Cambridge)](https://rwb27.github.io/openflexure_microscope/images/microscope_in_incubator.jpg)

The trick of making a microscope out of a webcam has been around for a little while, and produces good results.  However, getting a nice mechanical stage to focus the microscope and move around on the sample is tricky.  This project is a 3D printable design that enables very fine (sub-micron) mechanical positioning of the sample and the lens, with surprisingly good mechanical stability.  It's discussed in various [media articles](https://gitlab.com/openflexure/openflexure-microscope/wikis/Media-Articles) and a [paper in Review of Scientific Instruments](http://dx.doi.org/10.1063/1.4941068) (open access).

## Instructions
The editable instructions are MarkDown format, in the [docs folder](./docs/), and [they can be viewed on github pages](http://rwb27.github.io/openflexure_microscope/docs/).

## Printing it yourself
To build the microscope, go to [the tags page](https://gitlab.com/openflexure/openflexure-microscope/tags) and download the zip file containing the STL files from the latest release.  Don't just print everything from the folder, as there are a number of different configurations possible.  The [assembly instructions](http://rwb27.github.io/openflexure_microscope/docs/) contain instructions on what parts to print and how to build it.

If you've built one, let us know - add yourself to the [wiki page of builds](https://gitlab.com/openflexure/openflexure-microscope/wikis/Assembly-Logs) or submit an [issue](https://gitlab.com/openflexure/openflexure-microscope/issues/new) marked as a build report.  This is a really helpful thing to do even if you don't suggest improvements or flag up problems.

## Come join us!
Most of the development of this design has been done as part of various [research projects](http://www.bath.ac.uk/physics/contacts/academics/richard-bowman/index.html) - if you would like to join our research group at Bath, and you have funding or are interested in applying for it, do get in touch.  Check the University of Bath jobs site, or findaphd.com, to see if we are currently advertising any vacancies.  The team is bigger than Bath, though, and there are contibutors in Cambridge, Dar es Salaam, and beyond.

## Kits and License
This project is open-source and is released under the CERN open hardware license.  We are working on bring able to sell kits through [OpenFlexure Industries Ltd.](https://www.openflexure.com/), and will update here once we have a good way of doing it.


## Get Involved!
This project is open so that anyone can get involved, and you don't have to learn OpenSCAD to help (although that would be great).  Ways you can contribute include:

* Get involved in [discussions on gitter](https://gitter.im/OpenFlexure-Microscope/Lobby) [![Join the chat at https://gitter.im/OpenFlexure-Microscope/Lobby](https://badges.gitter.im/OpenFlexure-Microscope/Lobby.svg)](https://gitter.im/OpenFlexure-Microscope/Lobby?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
* Share your microscope images (of both microscopes and what you've seen with them) on social media - you can mention @openflexure on Twitter.
* [Raise an issue](https://gitlab.com/openflexure/openflexure-microscope/issues/) if you spot something that's wrong, or something that could be improved.  This includes the instructions/documentation.
* Suggest better text or images for the instructions.
* Improve the design of parts - even if you don't use OpenSCAD, STL files or descriptions of changes are helpful.
* Fork it, and make pull requests - again, documentation improvements are every bit as useful as revised OpenSCAD files.

Things in need of attention are currently described in [issues](https://gitlab.com/openflexure/openflexure-microscope/issues/) so have a look there if you'd like to work on something but aren't sure what.

## Developing
If you want to play with the OpenSCAD files or change the documentation, you should fork the repository.  You can edit the documentation online in GitLab, or clone the repository if you want to edit the OpenSCAD files.  NB you'll need to clone the whole repository as the OpenSCAD files are dependent on each other.

Also, by default this repository will store images using Git LFS, and is set up not to download these to your computer.  This is intended to make life easier for the members of our community who don't have fast internet connections.  If you want to download these, you can enable it with:
```bash
git lfs install
git config --local lfs.fetchexclude "/docs/original_images,/design_files"
git lfs fetch
git lfs checkout
```
NB the above commands will not download the full-resolution original images, or the design files.  New files will always be pushed.  If you don't need a local copy of the images, it's safe just to ignore this.

## Related Repositories
Most of the Openflexure Microscope stuff lives on GitHub, under [my account](https://github.com/rwb27/).  Particularly useful ones are:
* The ["sangaboard" motor controller](https://gitlab.com/bath_open_instrumentation_group/sangaboard) based on an Arduino + Darlington Pair ICs, developed collaboratively with [STICLab](http://www.sticlab.co.tz)
* The ["fergboard" motor controller](https://github.com/fr293/motor_board) by Fergus Riche
* An as-yet-quite-basic set of scripts that should become the [microscope software](https://github.com/rwb27/openflexure_microscope_software/)
* The higher precision, smaller range [block stage](https://github.com/rwb27/openflexure_block_stage)
* Some [characterisation scripts for analysing images of the USAF resolution test target](https://github.com/rwb27/usaf_analysis/)

## Compiling from source
If you want to print the current development version, you can compile the STL from the OpenSCAD files - but please still consult the documentation for quantities and tips on print settings, etc.  You can use GNU Make to generate all the STL files (run ``python generate_makefile.py`` and then ``make`` in the root directory of the repository).  More instructions, including hints for Windows users, are available in [COMPILE.md](COMPILE.md).
