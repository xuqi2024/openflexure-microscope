use <../libs/illumination.scad>

$fn=200;
condenser_with_annulus_stl();

module condenser_with_annulus_stl(){
    condenser(with_annulus=true);
}