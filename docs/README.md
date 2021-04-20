# OpenFlexure Microscope Documentation
The documentation is best viewed [on openflexure.org][built_docs].  If you have problems or want to suggest improvements, please [raise an issue] or even better edit the markdown file in this folder and send us a merge request.

The assembly instructions are contained in this folder, in BuildUp-markdown files. BuildUp is a version of markdown that contains metadata about part use. This allows [GitBuilding] to automatically generate the bill of materials. The markdown files themselves will make some sense if you view them directly, but certain things like the bill of materials will have not been counted yet. You're better off using the [processed versions][built_docs] on openflexure.org.

## Improving the documentation
If you would like to improve the documentation, the easiest way is to use the "edit" or "web IDE" features on GitLab.  Good instructions are super important, so it's really helpful to have suggestions and improvements from people who have built the microscope.  You can fork the repository and work on it locally if you prefer.

## Viewing and editing the instructions locally

To build and edit these instructions on your local machine you should install [GitBuilding]. However, you may find that many of the images and STL files that the documentation links to are missing.

This repository uses [Git LFS] to store the photos, you will need to install this before cloning the repository (see instructions in out main [README](../README.md)).

Also most of the documentation images are directly generated from OpenSCAD. You can run the render script locally. Or download the render [artifacts from GitLab][CI-jobs].

Similarly the STL file are directly generated from OpenSCAD so you can run our build script locally or download the build [artifacts from GitLab][CI-jobs].


[CI-jobs]: https://gitlab.com/openflexure/openflexure-microscope/-/jobs/
[built_docs]: https://www.openflexure.org/projects/microscope/docs/
[Git LFS]: https://git-lfs.github.com/
[GitBuilding]: https://gitbuilding.io
[raise an issue]: https://gitlab.com/openflexure/openflexure-microscope/issues/new
