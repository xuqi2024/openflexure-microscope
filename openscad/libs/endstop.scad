module endstop_switch(){
    cube([8.6,4.8,3]);
    //pads
    translate([-1.3,1,0]){
        cube([8.6+2*1.3,2.25,0.3]);
    }
    //bottom connectors
    translate([2.3,2.4,-0.6]){
        cylinder(r=0.55,h=1,$fn=50);
    }
    translate([6.3,2.4,-0.6]){
        cylinder(r=0.55,h=1,$fn=50);
    }
    //switch
    translate([2.56,1.05,2.9]){
        cube([1,2.7,0.6]);
    }
}

module endstop_hole(tilt){
    translate([4.3,-2.4,-2.9]){
        rotate_y(180){
            translate([-1.3,0,-3]){
                cube([11.4,4.8,0.6+3+0.2]);
            }
            translate([8.6,2.4,0]){
                rotate_y(tilt){
                    cylinder(r=1.3,h=20,$fn=40);
                }
            }
            translate([-0.3,2.4,0]){
                rotate_y(tilt){
                    cylinder(r=1.3,h=20,$fn=40);
                }
            }
        }
    }
}
