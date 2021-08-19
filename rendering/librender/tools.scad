use <../../openscad/libs/utilities.scad>
use <render_utils.scad>

oil_bottle();

module oil_bottle(){
    bottle_size = [50, 25, 60];
    nozzle_height = 22;
    neck_d=15;
    translate_z(-bottle_size.z-nozzle_height){
        coloured_render("DarkGreen"){
            outer_oil_bottle(bottle_size, neck_d=neck_d);
        }
        coloured_render("Red"){
            translate_z(bottle_size.z-tiny()){
                cylinder(d1=neck_d-1, d2=neck_d-2, h=5);
                cylinder(d1=4.5, d2=3, h=nozzle_height);
            }
        }
        rotate_z(180){
            coloured_render("White"){
                translate([0, -bottle_size.y/2-tiny(), bottle_size.z*.4]){
                    rotate_x(90){
                        linear_extrude(2*tiny()){
                            text("OIL",
                                size=10,
                                font="Sans",
                                halign="center",
                                valign="bottom");
                        }
                    }
                }
            }
        }
    }
}

module outer_oil_bottle(size, rad = 5, neck_d=15){
    abs_x_tr = size.x/2-rad;
    x_trs = [-abs_x_tr, abs_x_tr];
    abs_y_tr = size.y/2-rad;
    y_trs = [-abs_y_tr, abs_y_tr];
    hull(){
        for (x_tr = x_trs, y_tr = y_trs){
            translate([x_tr, y_tr, 0]){
                cylinder(r=rad, h=size.z-5, $fn=12);
            }
            
        }
        cylinder(d=neck_d, h=size.z, $fn=30);
    }
}