use <./libs/lib_microscope_stand.scad>

PI_VERSION = 4;
SANGA_VERSION = "v0.4";

pi_stand_stl(PI_VERSION, SANGA_VERSION);

module pi_stand_stl(pi_version=4, sanga_version="v0.4"){
    stand_params = default_stand_params(pi_version=pi_version,
                                        sanga_version=sanga_version);
    pi_stand(stand_params);
}
