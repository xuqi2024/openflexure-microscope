
use <../../openscad/libs/utilities.scad>
use <render_utils.scad>

module picamera2(lens=true){
    $fn = 20;
    picamera2_board();

    picamera2_front();
    picamera2_back();

    if (lens){
        translate([0,0,3]){
            picamera2_lens();
        }
    }
}

module picamera2_lens(){
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

module picamera2_front(){
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

module picamera2_back(){
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

function picamera2_size() = [23.862, 25, 1];
function picamera2_cam_pos_x() = 9.462;

function picamera2_holes() = let(
    cam_pos_x = picamera2_cam_pos_x(),
    h_y = picamera2_size().y/2-2,
    h_x1 = picamera2_size().x-2-cam_pos_x,
    h_x2 = picamera2_size().x-14.5-cam_pos_x
) [[h_x1, h_y, 0], [h_x1, -h_y, 0], [h_x2, h_y, 0], [h_x2, -h_y, 0]];

module picamera2_board_blank(x, y, t, cam_pos_x){
    //Translate camera to centre in xy, and board top to z=0
    translate([x/2-cam_pos_x, 0 ,-t]){
        filleted_board(x, y, t, r=2);
    }
}

module picamera2_board(){
    $fn = 20;
    cam_pos_x = picamera2_cam_pos_x();

    x = picamera2_size().x;
    y = picamera2_size().y;
    t = picamera2_size().z;
    // board except with cutout for screw clearance
    color("green"){
        render(){
            difference(){
                picamera2_board_blank(x, y, t, cam_pos_x);
                for (hole = picamera2_holes()){
                    translate(hole + [0, 0, -t]){
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
                picamera2_board_blank(x, y, t, cam_pos_x);
                for (hole = picamera2_holes()){
                    translate(hole + [0, 0, -t]){
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

module picamera2_tool(){
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
                translate([0, 0, -0.05]){
                    cylinder(d1 = 4.8, d2=19, h=7.1);
                }
            }
        }
    }
}

module motor28BYJ48_body(){
    holes = [[17.5, 0, 0], [-17.5, 0, 0]];
    translate([0, 8, 0]){
        cylinder(d=28, h=19);
        difference(){
            hull(){
                for (hole = holes){
                    translate(hole){
                        cylinder(r=3.5, h=.8);
                    }
                }
            }
            for (hole = holes){
                translate(hole){
                    cylinder(r=2.1, h=3, center=true);
                }
            }
        }
    }
    //centered at height 3 so 1.5mm is exposed
    cylinder(d=9, h=3, center=true);
}

module motor28BYJ48_wo_wire(){
    coloured_render("silver"){
        motor28BYJ48_body();
    }
    coloured_render("goldenrod"){
        intersection()
        {
            //centered at height 20 so 10mm is exposed
            cylinder(d=5, h=20, center=true);
            union(){
                cube([10, 10, 8], center=true);
                cube([10, 3, 99], center=true);
            }
        }
    }
    coloured_render("RoyalBlue"){
        translate([-14.5/2, 8, 0.1]){
            cube([14.5, 17, 16.5]);
        }
        translate([-17.5/2, 8, 4.1]){
            cube([17.5, 14, 12.5]);
        }
    }
}

module motor_jst_connector(){
    coloured_render("WhiteSmoke"){
        motor_jst_connector_body();
    }
    coloured_render("gray"){
        for (x_pin = [-2, -1, 0, 1, 2]*2.54){
            translate([x_pin, 0, 3.5]){
                cube([1.2, 3, 6], center=true);
            }
        }
    }
}

module motor_jst_connector_body(){
    difference(){
        union(){
            translate([0, 0, 7.7/2]){
                cube([13.2, 4, 7.7], center=true);
            }
            translate([0, .7/2, 7.3]){
                cube([14.6, 4.7, 0.8], center=true);
            }
            // the "clip"
            jst_connector_clip();
        }
        translate([0, -1.6, 0]){
            cube([99, 4, .6], center=true);
        }
        for (x_pin = [-2, -1, 0, 1, 2]*2.54){
            translate([x_pin, 0, 0]){
                jst_pin_void();
            }
        }
    }
}

module jst_connector_clip(){
    sequential_hull(){
        //x_gap is the space inside the clip in x
        x_gap = 8.6;
        //note everything is 1.0 in y and centred but it protrudes 0.8mm
        // Need to translate 2.8 in y to get this
        y_tr = -2.8;
        translate([x_gap/2, y_tr, 2]){
            cube([0.6, 1.6, 0.6]);
        }
        translate([x_gap/2, y_tr, 3.5]){
            cube([1.2, 1.6, 0.5]);
        }
        translate([x_gap/2, y_tr, 3.7]){
            cube([0.6, 1.6, 0.5]);
        }
        translate([x_gap/2, y_tr, 7.7-0.6]){
            cube([0.6, 1.6, 0.6]);
        }
        translate([-x_gap/2-0.6, y_tr, 7.7-0.6]){
            cube([0.6, 1.6, 0.6]);
        }
        translate([-x_gap/2-0.6, y_tr, 3.7]){
            cube([0.6, 1.6, 0.5]);
        }
        translate([-x_gap/2-1.2, y_tr, 3.5]){
            cube([1.2, 1.6, 0.5]);
        }
        translate([-x_gap/2-0.6, y_tr, 2]){
            cube([0.6, 1.6, 0.6]);
        }
    }
}

module jst_pin_void(){
        translate([0, 2, 0]){
            cube([1.2, 2, 6], center=true);
        }
        translate([0, 0, 6]){
            cube([2, 2.8, 10], center=true);
        }
        translate([0, .5, 6]){
            cube([1.2, 2.8, 10], center=true);
        }
        translate([0, -.7, 0]){
            cube([1, 1, 10], center=true);
        }
};


module motor28BYJ48_wire(m_pos, c_pos, m_pin, c_pin, points=[]){
    wire_start_m = [2, 17, 2.5];
    wire_end_m = [2, 27, 2.5];
    wire_pitch_m = [1, 0, 0];
    pin_tr_m = (m_pin-1)*(-wire_pitch_m);

    wire_start_c = [5.08, -.7, 6];
    wire_end_c = [2, -.7, 14];
    wire_pitch_cs = [2.54, 0, 0];
    wire_pitch_ce = [1, 0, 0];
    pin_tr_cs = (c_pin-1)*(-wire_pitch_cs);
    pin_tr_ce = (c_pin-1)*(-wire_pitch_ce);

    //wire near motor
    place_part(m_pos){
        hull(){
            translate(wire_start_m+pin_tr_m){
                sphere(d=1, $fn=10);
            }
            translate(wire_end_m+pin_tr_m){
                sphere(d=1, $fn=10);
            }
        }
    }
    //wire connector motor
    place_part(c_pos){
        hull(){
            translate(wire_start_c+pin_tr_cs){
                sphere(d=1, $fn=10);
            }
            translate(wire_end_c+pin_tr_ce){
                sphere(d=1, $fn=10);
            }
        }
    }
    //the rest of the wire
    //can reduce this block of code if there was a way to create a
    // pacement dictionary where the part is tranlated before the placement is applied
    // This requires function with a lot of algebra
    if (len(points) == 0){
        hull(){
            place_part(m_pos){
                translate(wire_end_m+pin_tr_m){
                    sphere(d=1, $fn=10);
                }
            }
            place_part(c_pos){
                translate(wire_end_c+pin_tr_ce){
                    sphere(d=1, $fn=10);
                }
            }
        }
    }
    else{
        w_points = calc_bundled_wire_points(5, m_pin, points);
        hull(){
            place_part(m_pos){
                translate(wire_end_m+pin_tr_m){
                    sphere(d=1, $fn=10);
                }
            }
            translate(w_points[0]){
                sphere(d=1, $fn=10);
            }
        }
        if (len(w_points) > 1){
            wire(d=1, points=w_points);
        }
        hull(){
            translate(w_points[len(w_points)-1]){
                sphere(d=1, $fn=10);
            }
            place_part(c_pos){
                translate(wire_end_c+pin_tr_ce){
                    sphere(d=1, $fn=10);
                }
            }
        }
    }
}

function calc_bundled_wire_points(n_wires, wire_num, points) = let(
    off_x = cos(360*wire_num/n_wires),
    off_y = sin(360*wire_num/n_wires)
)[
    for (point = points)
        if (len(point)==3)
            point + [off_x, off_y, 0]
        else
            let(
                beta = point[3],
                gamma = point[4],
                x = point[0] + cos(beta)*cos(gamma)*off_x - sin(beta)*off_y,
                y = point[1] + sin(beta)*cos(gamma)*off_x + cos(beta)*off_y,
                z = point[2] + sin(gamma)*off_x
            )  [x, y, z]
];


module motor28BYJ48(motor_pos, connector_pos, wire_points=[]){
    m_pos = is_undef(motor_pos) ? create_placement_dict([0, 0, 0]) : motor_pos;
    c_pos = is_undef(connector_pos) ? create_placement_dict([0, 280, 0], [90, 0, 0]) : connector_pos;
    place_part(m_pos){
        motor28BYJ48_wo_wire();
    }
    place_part(c_pos){
        motor_jst_connector();
    }

    coloured_render("Orange"){
        motor28BYJ48_wire(m_pos, c_pos, 1, 4, wire_points);
    }
    coloured_render("Yellow"){
        motor28BYJ48_wire(m_pos, c_pos, 2, 3, wire_points);
    }
    coloured_render("Red"){
        motor28BYJ48_wire(m_pos, c_pos, 3, 5, wire_points);
    }
    coloured_render("Blue"){
        motor28BYJ48_wire(m_pos, c_pos, 4, 1, wire_points);
    }
    coloured_render("Magenta"){
        motor28BYJ48_wire(m_pos, c_pos, 5, 2, wire_points);
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

module wire(d=1, points=[[0, 0, 0], [10,0,0]]){
    $fn=10;
    for(i=[0:len(points)-2]){
        hull(){
            translate(points[i]){
                sphere(d=d);
            }
            translate(points[i+1]){
                sphere(d=d);
            }
        }
    }
}