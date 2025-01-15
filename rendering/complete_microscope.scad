use <./mount_electronics.scad>

OPTICS_VERSION = "rms";
Manual = false;

render_complete_microscope(OPTICS_VERSION, MANUAL);

module render_complete_microscope(optics_version="rms", manual=false){
    render_microscope(optics_version=optics_version, manual=manual);
}
