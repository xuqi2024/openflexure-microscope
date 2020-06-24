# OpenFlexure Microscope
The OpenFlexure Microscope is a  3D printable microscope, including a precise mechanical stage to move the sample and focus the optics.  There are many different options for the optics, ranging from a webcam lens to a 100x, oil immersion objective.

![A trio of microscopes](https://openflexure.org/assets/MicroscopeBlenderTrio.png)

The trick of making a microscope out of a webcam has been around for a little while, and produces good results.  However, getting a nice mechanical stage to focus the microscope and move around on the sample is tricky.  This project is a 3D printable design that enables very fine (sub-micron) mechanical positioning of the sample and the lens, with surprisingly good mechanical stability.  It's discussed in various [media articles](https://gitlab.com/openflexure/openflexure-microscope/wikis/Media-Articles) and a [paper in Review of Scientific Instruments](http://dx.doi.org/10.1063/1.4941068) (open access).

## Building a microscope
For up-to-date build instructions and STL files, please head to the [build a microscope page].

[build a microscope page]: https://openflexure.org/projects/microscope/build

## Instructions
The editable instructions are MarkDown format, in the [docs folder](./docs/), and the latest release docs will be compiled into a web page linked from the [build a microscope page].

## Printing it yourself
To build the microscope, go to the [build a microscope page] and check the instructions on printing.  Don't just print everything from the zip file download, as there are a number of different configurations possible - we're working on an automatic way to let you download just the right files.  The [assembly instructions](https://build.openflexure.org/openflexure-microscope/latest/docs) contain instructions on what parts to print and how to build it.

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

### Development environment
We mostly use VSCode to edit the OpenSCAD files, and then use OpenSCAD with the editor hidden and the "automatic reload and compile" option ticked.  This is much nicer for a big multi-file project like the microscope than relying on OpenSCAD's built-in editor, and also works nicely with version control.  NB you can edit ``microscope_parameters.scad`` to change which options you build in the OpenSCAD window, but it's best not to commit changes to that file unless you need to change the default values.

### Automatic builds
The build system is based on Python and Ninja, see [compiling](COMPILE.md) for more details.

### Release flow
We use GitLab CI to manage builds and deployment. 

The CI will build STL files that expire after 1 week when:
* A build is manually triggered from GitLab web
* A merge request is submitted
* A merge request is modified
* A release is tagged

The CI will deploy the built STL files, and documentation, to [build.openflexure.org](https://build.openflexure.org/) when:
* A build is manually triggered from GitLab web
* A release is tagged

The build server will mark a release as "latest" ([build.openflexure.org/openflexure-microscope/latest](https://build.openflexure.org/openflexure-microscope/latest)) when:
* A release is tagged, with a semantic version and no suffix. For example:
  * v6.0.0 will replace "latest"
  * v6.0.1-beta.1 will **not** replace "latest" (pre-release suffix)
  * v6.1 will **not** replace "latest" (no patch version specified)
  * 6.0.1a will **not** replace "latest" (non-standard suffix)

### LFS files

This repository will store images using Git LFS, and **is set up not to download these to your computer**.  This is intended to make life easier for the members of our community who don't have fast internet connections or want to save storage space.  If you want to download these files you will need to [install Git LFS](https://git-lfs.github.com/). Once installed to your computer Git LFS will need to be installed by running the following command in your terminal
```bash
git lfs install
```

Now Git LFS is installed you can modify what to download.

**Download images used in the documentation**

To make Git always download the images used in the documentation (but not high-res images or design files) run the following commands in your terminal
```
git config --local lfs.fetchexclude "/docs/original_images,/design_files"
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
The OpenFlexure repositories have been gradually migrating from [Richard's Github](https://github.com/rwb27/) to GitLab.  Particularly useful ones are:
Most of the Openflexure Microscope stuff lives in the [OpenFlexure group on GitLab](https://gitlab.com/openflexure).  Particularly useful ones are:
* The [microscope server software](https://gitlab.com/openflexure/openflexure-microscope-server)
* The [microscope client software](https://gitlab.com/openflexure/openflexure-microscope-jsclient)
* The higher precision, smaller range [block stage](https://gitlab.com/openflexure/openflexure-block-stage)
A number of other related projects developed by us and our collaborators include:
* The ["sangaboard" motor controller](https://gitlab.com/bath_open_instrumentation_group/sangaboard) based on an Arduino + Darlington Pair ICs, developed collaboratively with [STICLab](http://www.sticlab.co.tz)
* The ["fergboard" motor controller](https://github.com/fr293/motor_board) by Fergus Riche
* Some [characterisation scripts for analysing images of the USAF resolution test target](https://github.com/rwb27/usaf_analysis/)

## Compiling from source
If you want to print the current development version, you can compile the STL from the OpenSCAD files - but please still consult the documentation for quantities and tips on print settings, etc.  You can use Ninja build to generate all the STL files (run ``pip3 install -r requirements.txt`` and then ``./build.py`` in the root directory of the repository).  More instructions are available in [COMPILE.md](COMPILE.md).
