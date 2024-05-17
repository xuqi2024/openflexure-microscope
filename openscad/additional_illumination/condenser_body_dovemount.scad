use <../libs/illumination.scad>

$fn=200;
condenser_body_dovemount_stl();

module condenser_body_dovemount_stl(){
    condenser(dovetail_stop_thickness=2, include_gripper=false, include_mounting=true, basic_condenser=false);
}