use <./illumination.scad>

translate([0,0,-illumination_dovetail_z()]){
    illumination_dovetail(h = 50);
}
