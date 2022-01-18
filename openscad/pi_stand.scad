use <./libs/lib_microscope_stand.scad>

pi_stand_stl();

module pi_stand_stl(pi_version=4, sanga_version="v0.4"){
    stand_params = default_stand_params(pi_version=pi_version,
                                        sanga_version=sanga_version);
    pi_stand(stand_params);
}
