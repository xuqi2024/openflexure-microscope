use <./libs/lib_microscope_stand.scad>

PI_VERSION = 4;
SANGA_VERSION = "v0.4";

electronics_drawer_stl(PI_VERSION, SANGA_VERSION);

module electronics_drawer_stl(pi_version=4, sanga_version="v0.4"){
    stand_params = default_stand_params(pi_version=pi_version,
                                        sanga_version=sanga_version);
    electronics_drawer(stand_params);
}
