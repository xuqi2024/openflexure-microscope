use <libs/utilities.scad>
use <libs/lib_gear_tools.scad>

translate_y(40){
    nut_spinner();
}

translate_y(20){
    difference(){
        gear_holder(ratio=2);
        translate_z(4.4){
            linear_extrude(10){
                text("2:1", valign="center", halign="center", size=4);
            }
        }
    }
}

difference(){
    gear_holder(ratio=18/18);
        translate_z(4.4){
            linear_extrude(10){
                text("1:1", valign="center", halign="center", size=4);
            }
        }
}

translate_y(-20){
    difference(){
        gear_holder(ratio=16/20);
        translate_z(4.4){
            linear_extrude(10){
                text("0.8:1", valign="center", halign="center", size=4);
            }
        }
    }
}