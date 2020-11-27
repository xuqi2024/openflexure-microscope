use <./illumination.scad>

translate([0,0,-illumination_dovetail_z()]){
    illumination_dovetail(params, h = 50);
}
