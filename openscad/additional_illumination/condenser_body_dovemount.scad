use <../libs/illumination.scad>

$fn=200;
condenser_body_dovemount_stl();

module condenser_body_dovemount_stl(){
    // NB the module is called in the renders with default arguments.  If
    // non-default arguments are used here, it will mean the STL doesn't
    // match the renders.
    condenser(dovetail_stop_thickness=2, include_gripper=false, include_mounting=true, basic_condenser=false);
}