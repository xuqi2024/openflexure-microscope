# OpenFlexure Microscope
The OpenFlexure Microscope is a  3D printable microscope, including a precise mechanical stage to move the sample and focus the optics.  There are many different options for the optics, ranging from a webcam lens to a 100x, oil immersion objective.

![A trio of microscopes](https://openflexure.org/assets/MicroscopeBlenderTrio.png)

The trick of making a microscope out of a webcam has been around for a little while, and produces good results.  However, getting a nice mechanical stage to focus the microscope and move around on the sample is tricky.  This project is a 3D printable design that enables very fine (sub-micron) mechanical positioning of the sample and the lens, with surprisingly good mechanical stability.  It's discussed in various [media articles](https://gitlab.com/openflexure/openflexure-microscope/wikis/Media-Articles).

If you use the OpenFlexure microscope in you work please consider citing one of our papers:

* *Robotic microscopy for everyone: the OpenFlexure microscope*, [Biomedical Optics Express **11** 2447 (2020)](https://doi.org/10.1364/BOE.385729) (open access).
* *A one-piece 3D printed flexure translation stage for open-source microscopy*, [Review of Scientific Instruments **87**, 025104 (2016)](http://dx.doi.org/10.1063/1.4941068) (open access).

## Building a microscope
For up-to-date build instructions, STL files, and pre-built Raspberry Pi SD images, please head to the [build a microscope page].

[build a microscope page]: https://openflexure.org/projects/microscope/build

## Instructions
The latest release of our assembly documentation can be found from the [build a microscope page] on our website. The editable instructions are Markdown format, in the [docs folder](./docs/) of this repository. If you have a problem accessing the images after cloning the repository see the section on LFS files below.

## Printing it yourself
Configure your microscope hardware and download the STL files through the [microscope STL configurator] page.  The [assembly instructions](https://build.openflexure.org/openflexure-microscope/latest/docs) contain instructions on print settings and putting it together.

If you've built one, let us know. You can let us know on [our forum](https://openflexure.discourse.group/), add yourself to the [wiki page of builds](https://gitlab.com/openflexure/openflexure-microscope/wikis/Assembly-Logs), or submit an [issue](https://gitlab.com/openflexure/openflexure-microscope/issues/new) marked as a build report.  This is a really helpful for us even if you don't suggest improvements or flag up problems.

[microscope STL configurator]: https://microscope-stls.openflexure.org

## Come join us!
Most of the development of this design has been done as part of various [research projects](http://www.bath.ac.uk/physics/contacts/academics/richard-bowman/index.html) - if you would like to join our research group at Bath, and you have funding or are interested in applying for it, do get in touch.  Check the University of Bath jobs site, or findaphd.com, to see if we are currently advertising any vacancies.  The team is bigger than Bath, though, and there are contributors in Cambridge, Dar es Salaam, and beyond.

## Kits and License
This project is open-source and is released under the CERN open hardware license.  We are working on bring able to sell kits through [OpenFlexure Industries Ltd.](https://www.openflexure.com/), and will update here once we have a good way of doing it.

## Get Involved!
This project is open so that anyone can get involved, and you don't have to learn OpenSCAD to help (although that would be great).  Ways you can contribute include:

* [Join our forum](https://openflexure.discourse.group/)
* Get involved in [discussions on gitter] (we use this less than the forum)(https://gitter.im/OpenFlexure-Microscope/Lobby) [![Join the chat at https://gitter.im/OpenFlexure-Microscope/Lobby](https://badges.gitter.im/OpenFlexure-Microscope/Lobby.svg)](https://gitter.im/OpenFlexure-Microscope/Lobby?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
* Share your microscope images (of both microscopes and what you've seen with them) on social media - you can mention @openflexure on Twitter.
* [Raise an issue on the helpdesk](https://gitlab.com/openflexure/openflexure-helpdesk/-/issues) if you spot something that's wrong, or something that could be improved.  Helpdesk issues can be about anything to do with the project including the instructions/documentation, the software, etc.
* Suggest better text or images for the instructions.
* Improve the design of parts - even if you don't use OpenSCAD, STL files or descriptions of changes are helpful.
* Fork it, and make merge requests - again, documentation improvements are every bit as useful as revised OpenSCAD files.

Things in need of attention are currently described in [issues](https://gitlab.com/openflexure/openflexure-microscope/issues/) so have a look there if you'd like to work on something but aren't sure what.

## Developing
If you want to play with the OpenSCAD files or change the documentation, you should fork the repository.  You can edit the documentation online in GitLab, or clone the repository if you want to edit the OpenSCAD files.  You will need to clone the whole repository as the OpenSCAD files are dependent on each other.

### Development environment
We mostly use VSCode to edit the OpenSCAD files, and then use OpenSCAD with the editor hidden and the "automatic reload and compile" option ticked.  This is much nicer for a big multi-file project like the microscope than relying on OpenSCAD's built-in editor, and also works nicely with version control.

You can edit ``microscope_parameters.scad`` to change which options you build in the OpenSCAD window, but it's best not to commit changes to that file unless you need to change the default values.

### Automatic builds
The build system is based on Python and Ninja, see [compiling](COMPILE.md) for more details.

### Release flow
We use GitLab CI to manage builds and deployment.

The CI will build STL files that will remain on GitLab for 1 week when:

* A merge request is submitted
* A merge request is modified

The CI will build and deploy STL files and documentation to [build.openflexure.org](https://build.openflexure.org/) when:
* A build is manually triggered from GitLab web
* A release is tagged

The build server will mark a release as "latest" ([build.openflexure.org/openflexure-microscope/latest](https://build.openflexure.org/openflexure-microscope/latest)) when a release is tagged, with a full semantic version and no suffix. For example:
  * v6.0.0 will replace "latest"

However, incomplete semantic versions will not replace latest. For example:
  * v6.0.1-beta.1 will **not** replace "latest" (pre-release suffix)
  * v6.1 will **not** replace "latest" (no patch version specified)
  * 6.0.1a will **not** replace "latest" (non-standard suffix)

### LFS files

This repository stores images using Git LFS. This means that cloning the repository without Git LFS installed will only download placeholders for the images. Follow these instructions to [install Git LFS](https://git-lfs.github.com/).

With LFS installed Git will download the latest version of the images used in the documentation. If they are still missing try running:
```
git lfs fetch
git lfs checkout
```

**Download all files**

To make Git always download *everything* in the repository run the following commands in your terminal:
```
git config --local lfs.fetchexclude ""
git lfs fetch
git lfs checkout
```


## Related Repositories

Other repositories relating to the Openflexure Microscope are in the [OpenFlexure GitLab group](https://gitlab.com/openflexure).  Particularly useful ones are:

* [OpenFlexure Microscope Server](https://gitlab.com/openflexure/openflexure-microscope-server). This is the software that runs on the microscope.
* [OpenFlexure Connect](https://gitlab.com/openflexure/openflexure-connect). The recommended client software for controlling the microscope. The repository is mostly device discovery code, with the interface handled by the server.
* [OpenFlexure Microscope Python Client](https://gitlab.com/openflexure/openflexure-microscope-pyclient). This allows you to control a microscope from a python script.
* [OpenFlexure Delta Stage](https://gitlab.com/openflexure/openflexure-delta-stage). A 3-axis stage for microscopy that keeps the objective in a fixed position.
* [OpenFlexure Block Stage](https://gitlab.com/openflexure/openflexure-block-stage). A higher precision 3-axis stage with a smaller range.

Repositories for compatible motor controllers:
* The ["sangaboard" motor controller](https://gitlab.com/bath_open_instrumentation_group/sangaboard). The standard motor controller for the microscope. Developed collaboratively with [STICLab](http://www.sticlab.co.tz)
* The ["fergboard" motor controller](https://github.com/fr293/motor_board) by Fergus Riche.

A number of other related projects include:

* [micat](https://gitlab.com/bath_open_instrumentation_group/micat) For microscope calibration
* [PiCamera CRA Compensation](https://gitlab.com/bath_open_instrumentation_group/picamera_cra_compensation/) Contains hardware and software for colour calibration of a Raspberry Pi camera.
* Some [characterisation scripts for analysing images of the USAF resolution test target](https://github.com/rwb27/usaf_analysis/)

Some open flexure repositories still remain on [Richard's Github](https://github.com/rwb27/).

## Compiling from source
If you want to print the current development version, you can compile the STL from the OpenSCAD files - but please still consult the documentation for quantities and tips on print settings, etc.  You can use Ninja build to generate all the STL files (run ``pip3 install -r requirements.txt`` and then ``./build.py`` in the root directory of the repository).  More instructions are available in [COMPILE.md](COMPILE.md).
