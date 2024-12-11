use <./mount_electronics.scad>


LOW_COST = true;
render_complete_microscope(LOW_COST);

module render_complete_microscope(low_cost=false){
    render_microscope(low_cost);
}
