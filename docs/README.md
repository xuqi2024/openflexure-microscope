# OpenFlexure Microscope Documentation
The documentation is best viewed [on openflexure.org][built_docs].  If you have problems or want to suggest improvements, please [raise an issue] or even better edit the markdown file in this folder and send us a pull request.

The assembly instructions are contained in this folder, in MarkDown format.  They will eventually use [Git-Building] to automatically generate the bill of materials, which means the markdown files will make sense if you view them directly, but you're better off using the [processed versions][built_docs] on openflexure.org.

## Improving the documentation
If you would like to improve the documentation, the easiest way is to use the "edit" or "web IDE" features on GitLab.  Good instructions are super important, so it's really helpful to have suggestions and improvements from people who have built the microscope.  You can fork the repository and work on it locally if you prefer.  

**Please note that this repository uses [Git LFS] and that, by default, it won't download the images for the documentation** (before switching to LFS, it was a 1.5Gb download to clone the repository, which causes real problems for some of the team).  To change which files Git LFS downloads please see the instructions in the main [README](../README.md) for the repository.

## Build instructions
Currently, the process of getting the docs onto [openflexure.org][built_docs] is a bit manual; first you need to add Jekyll "front matter" to the pages and copy them into a new location.  That's done by ``build_docs.py`` (in this directory - use Python 3 or it won't work).  You can then copy all the files from the built directory (``../builds/docs/`` by default) into the relevant folder in the repoisitory for openflexure.gitlab.io, and push to master at which point the Jekyll site will be built.  We will hopefully switch to using gitbuilding in the near future to improve this and automate our bill of materials generation.  You can of course serve the output folder as a Jekyll site directly if you add a config file, but bear in mind that it might get deleted when you rebuild the output folder, so keep a copy somewhere else!  This will be fixed in the future when we are using gitbuilding.

[built_docs]: https://www.openflexure.org/projects/microscope/docs/
[Git LFS]: https://git-lfs.github.com/
[Git-Building]: https://gitlab.com/bath_open_instrumentation_group/git-building
[raise an issue]: https://gitlab.com/openflexure/openflexure-microscope/issues/new