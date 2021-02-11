
module pi_camera2(lens=true){
    $fn = 20;
    pi_camera2_board();

    pi_camera2_front();
    pi_camera2_back();

    if (lens){
        translate([0,0,3]){
            pi_camera2_lens();
        }
    }
}

module pi_camera2_lens(){
    $fn = 20;
    color("#404040"){
        render(){
            difference(){
                union(){
                    cylinder(d=6, h=2);
                    translate([0, 0, 1.95]){
                        cylinder(d1=6, d2=4, h=1);
                        cube([5, 1.8, 2],center=true);
                        cube([1.8, 5, 2],center=true);
                    }
                }
                translate([0, 0, -.02]){
                    cylinder(d1=4, d2=1, h=3);
                }
            }
        }
    }
    color("PaleTurquoise", .60){
        cylinder(d1=4, d2=1, h=3);
    }
}

module pi_camera2_front(){
    color("black"){
        cylinder(d=6, h=1);
        translate([8, -3, 0]){
            cube([3, 8, 1]);
        }
    }

    color("DimGray"){
        translate([-8.5/2, -8.5/2, 1]){
            cube([8.5, 8.5, 2]);
        }
        translate([0,0,3]){
            difference(){
                cylinder(d=7.3, h=1.5);
                cylinder(d=6.5, h=99, center=true);
            }
        }
        translate([7.5, -3.5, 1]){
            cube([4, 9, .3]);
        }
        translate([0, -3.5, 1]){
            cube([8, 7, .3]);
        }
    }
    color("DarkSlateBlue"){
        translate([-3/2, -4/2, 2.1]){
            cube([3, 4, 1]);
        }
    }
}

module pi_camera2_back(){
    translate([0,0,-1]){
        mirror([0,0,1]){

            color("DimGray"){
                translate([-9, -21/2, 0]){
                    cube([1, 21, 2.5]);
                }
            }
            color("Tan"){
                translate([-8, -19/2, 0]){
                    cube([4, 19, 2.5]);
                }
            }

            //chips appox for visual similarity
            chip(6, -8, 1.5, 3, .5);
            chip(6, -3, 1.5, 3, .5);
            chip(10, -5.5, 2.5, 2, .5);

            chip(4, 1, 1.5, 1, .5);
            chip(2, 3, 2, 3, .5);
            chip(-1, 3, 1, 2, 1);
            chip(-1, -6, 1.5, 1.5, .5);
            chip(-1, -3, 1.5, 1.5, .5);
            chip(-1, 0, 1.5, 1.5, .5);

            chip(5, 6, 2, 3, 1);
            chip(7, 6, 1, 3, 1);

            chip(6, 10.5, 3, 2, 1);

        }
    }
}

module chip(x, y, w, h, t){
    color("#404040"){
        translate([x-w/2, y-h/2, 0]){
            cube([w, h, t]);
        }
    }
}



module pi_camera2_board(){
    $fn = 20;
    x = 23.862;
    y = 25;
    t = 1;
    //hole positions (before translating the camera to centre
    h_y = y/2-2;
    h_x1 = x/2-2;
    h_x2 = x/2-14.5;
    holes = [[h_x1, h_y, 0], [h_x1, -h_y, 0], [h_x2, h_y, 0], [h_x2, -h_y, 0]];

    cam_pos_x = 9.462;
    //Translate camera to centre in xy, and board top to z=0
    translate([x/2-cam_pos_x, 0 ,-t]){
        // board except with cutout for screw clearance
        color("green"){
            render(){
                difference(){
                    filleted_board(x, y, t, r=2);
                    for (hole = holes){
                        translate(hole){
                            cylinder(d=5, h=99, center=true);
                        }
                    }
                }
            }
        }
        // screw clearance area
        color("darkkhaki"){
            render(){
                intersection(){
                    filleted_board(x, y, t, r=2);
                    for (hole = holes){
                        translate(hole){
                            difference(){
                                cylinder(d=5, h=t);
                                cylinder(d=2.2, h=99, center=true);
                            }
                        }
                    }
                }
            }
        }
    }

}

module pi_camera2_tool(){
    $fn=30;
    color("#CCCCCC"){
        difference(){
            cylinder(d = 7, h=1.6);
            cylinder(d = 4.8, h=99,center=true);
        }
        translate([0, 0, 1.6]){
            difference(){
                cylinder(d=22.7,h=7);
                cylinder(d=19,h=99, center=true);
            }
            difference(){
                cylinder(d1 = 7, d2=22.7,h=7);
                translate([0, 0, -0.05])
                cylinder(d1 = 4.8, d2=19, h=7.1);
            }
        }
    }
}

module filleted_board(x, y, t, r=2){
    x_tr = x/2-r;
    y_tr = y/2-r;
    hull(){
        translate([x_tr, y_tr, 0]){
            cylinder(r=r, h=t);
        }
        translate([x_tr, -y_tr, 0]){
            cylinder(r=r, h=t);
        }
        translate([-x_tr, y_tr, 0]){
            cylinder(r=r, h=t);
        }
        translate([-x_tr, -y_tr, 0]){
            cylinder(r=r, h=t);
        }
    }
}