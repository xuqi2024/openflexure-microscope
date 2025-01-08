use <./mount_electronics.scad>


OPTICS_VERSION = "rms";
render_complete_microscope(OPTICS_VERSION);

module render_complete_microscope(optics_version="rms"){
    render_microscope(optics_version=optics_version);
}
