
use <../../openscad/libs/utilities.scad>
use <../../openscad/libs/lib_microscope_stand.scad>
use <render_utils.scad>

$fn = 12;

module rpi_4b(){
    rpi_4b_board();
    rpi_4b_ports();
    rpi_4b_top_chips();
}

module rpi_4b_top_chips(){
    translate_z(pi_board_dims().z){
        chip(12, 42, 10.7, 13, 1, "Silver");
        chip(29, 32.5, 15, 15, 1, "Silver");
        chip(29, 32.5, 13, 13, 1.5, "Silver");
        chip(44, 32.5, 10, 15, 1.5);
        chip(60, 24, 8, 8, .5);
        chip(59, 38, 6, 6, .5);
        chip(68.5, 34, 3.5, 7, 2);
    }
}

module rpi_4b_ports(){
    size = pi_board_dims();
    translate([2, size.y/2, size.z]){
        csi_port(vertical=true);
    }
    translate([45, 11, size.z]){
        csi_port(vertical=true);
    }
    translate([11.2, 0, size.z]){
        usb_c_socket();
    }
    translate([26, 0, size.z]){
        mini_hdmi_socket();
    }
    translate([39.5, 0, size.z]){
        mini_hdmi_socket();
    }
    translate([54, 0, size.z]){
        audio_jack_socket();
    }
    translate([size.x, 9, size.z]){
        rotate_z(90){
            dual_usb_socket();
        }
    }
    translate([size.x, 27, size.z]){
        rotate_z(90){
            dual_usb_socket(usb3=true);
        }
    }
    translate([size.x, 46, size.z]){
        rotate_z(90){
            ethernet_socket();
        }
    }
    translate([7, size.y-3, size.z]){
        double_header_pins(20);
    }
    translate([61.5, 44, size.z]){
        rotate_z(90){
            double_header_pins(2);
        }
    }
    mirror([0, 0, 1]){
        translate_y(size.y/2){
            rotate_z(-90){
                micro_sd_slot();
            }
        }
    }
}

module rpi_4b_board(){
    size = pi_board_dims();
    //Translate camera to centre in xy, and board top to z=0
    coloured_render("green"){
        difference(){
            filleted_board(size, r=2);
            for (hole = pi_hole_pos()){
                translate(hole){
                    cylinder(d=6, h=10, center=true);
                }
            }
        }
    }

    coloured_render("darkkhaki"){
        for (hole = pi_hole_pos()){
            translate(hole){
                difference(){
                    cylinder(d=6, h=size.z);
                    cylinder(d=2.8, h=99, center=true);
                }
            }
        }
    }

}



module picamera2(lens=true){
    $fn = 20;
    picamera2_board();

    picamera2_front();
    picamera2_back();

    if (lens){
        translate_z(3){
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
                    translate_z(1.95){
                        cylinder(d1=6, d2=4, h=1);
                        cube([5, 1.8, 2],center=true);
                        cube([1.8, 5, 2],center=true);
                    }
                }
                translate_z(-.02){
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
        translate_z(3){
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
    translate_z(-1){
        mirror([0,0,1]){
            translate_x(-8){
                csi_port();
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

module chip(x, y, w, h, t, colour="#404040"){
    color(colour){
        translate([x-w/2, y-h/2, 0]){
            cube([w, h, t]);
        }
    }
}

module csi_port(vertical=false){
    rotation = vertical ? 90 : 0;
    z_tr = vertical ? 4 : 0;
    translate_z(z_tr){
        rotate_y(rotation){
            color("DimGray"){
                translate([-1, -21/2, 0]){
                    cube([1, 21, 2.5]);
                }
            }
            color("Tan"){
                translate([0, -19/2, 0]){
                    cube([4, 19, 2.5]);
                }
            }
        }
    }
}

module audio_jack_socket(){
    color("DimGray"){
        translate_z(3.5){
            difference(){
                union(){
                    translate_y(6){
                        cube([7, 12, 6], center=true);
                    }
                    
                    rotate_x(90){
                        cylinder(d=6, h=5, center=true);
                    }
                }
                rotate_x(90){
                    cylinder(d=3.5, h=99, center=true);
                }
            }
        }
    }
}

module mini_hdmi_socket(){
    color("Silver"){
        translate_y(-1.8){
            difference(){
                minkowski(){
                    mini_hdmi_shape();
                    rotate_x(-90){
                        cylinder(r=.5, h=tiny());
                    }
                }
                translate_y(-1){
                    mini_hdmi_shape();
                }
                for(x_tr = [2.5, -2.5]){
                    translate_x(x_tr){
                        cube([1, 2, 99], center=true);
                    }
                }
            }
        }
    }
    color("DimGray"){
        translate([-2, 0, 1]){
            cube([4, 4 , 1]);
        }
        translate_y(4){
            mini_hdmi_shape(1);
        }
    }
}

module mini_hdmi_shape(depth=8){
    hull(){
        for(x_tr = [2.5, -2.5]){
            translate([x_tr, 0, 1]){
                rotate_x(-90){
                    cylinder(d=1, h=depth);
                }
            }
        }
        translate([-3, 0, 2.5]){
            cube([6, depth, .5]);
        }
    }
}

module usb_c_socket(){
    color("Silver"){
        translate_y(-1.8){
            difference(){
                minkowski(){
                    usb_c_shape();
                    rotate_x(-90){
                        cylinder(r=.5, h=tiny());
                    }
                }
                translate_y(-1){
                    usb_c_shape();
                }
                for(x_tr = [2.5, -2.5]){
                    translate_x(x_tr){
                        cube([1, 2, 99], center=true);
                    }
                }
            }
        }
    }
    color("DimGray"){
        translate([-3, -1.5, 1]){
            cube([6, 7 , 1]);
        }
        translate_y(4){
            usb_c_shape(1.7);
        }
    }
}

module usb_c_shape(depth=7.3){
    hull(){
        for(x_tr = [3, -3]){
            for(z_tr = [1, 2]){
                translate([x_tr, 0, z_tr]){
                    rotate_x(-90){
                        cylinder(d=1, h=depth);
                    }
                }
            }
        }
    }
}


module dual_usb_socket(usb3=false){
    usb_col = usb3 ? "DodgerBlue" : "DimGray";
    usb_zs = [4.5, 12.5];
    translate_y(-3){
        color("Silver"){
            difference(){
                dual_usb_socket_outer();

                for (z_tr = usb_zs){
                    translate_z(z_tr){
                        cube([12, 30, 5], center=true);
                    }
                }
            }
        }
        color(usb_col){
            for (z_tr = usb_zs){
                translate([-11/2, .5, z_tr+.5]){
                    cube([11, 15, 1.5]);
                }
            }
        }
    }
}


module dual_usb_socket_outer(){
    translate([-13/2, 0, 1.5]){
        cube([13, 17.5, 14]);
    }
    for (i = [-1, 1]){
        translate([i*12.5/2 -.25, 9.5, -3]){
            difference(){
                cube([0.5, 8, 6]);
                translate([-tiny(), 2, -2]){
                    cube([1, 4, 6]);
                }
            }
        }
    }
    translate([-15/2, 0, 2.5]){
        cube([15, .5, 12]);
    }
    translate([-11/2, 0, .5]){
        cube([11, .5, 16]);
    }
}

module ethernet_socket(){
    translate_y(-3){
        color("Silver"){
            difference(){
                translate_x(-8){
                    cube([16, 21, 13.3]);
                }
                translate_y(-tiny()){
                    ethernet_socket_cutout(depth=13.5, enlarge=.5);
                }
            }
        }
        color("DimGray"){
            difference(){
                ethernet_socket_cutout(depth=13, enlarge=.5);
                translate_y(-tiny()){
                    ethernet_socket_cutout(depth=13);
                }
            }
        }
        color("Green"){
            translate([-4.75, 0, 2.75]){
                cube([3, 2*tiny(), 1.5], center=true);
            }
        }
        color("Yellow"){
            translate([4.75, 0, 2.75]){
                cube([3, 2*tiny(), 1.5], center=true);
            }
        }
    }
}

module ethernet_socket_cutout(depth, enlarge=0){
    size = [12, depth, 7] + [enlarge, 0, enlarge];
    nub1_size = [6.3, depth, 7] + [enlarge, 0, enlarge];
    nub2_size = [4, depth, 7] + [enlarge, 0, enlarge];
    translate([-size.x/2, 0, 3.7-enlarge/2]){
        cube(size);
    }
    translate([-nub1_size.x/2, 0, 2.2-enlarge/2]){
        cube(nub1_size);
    }
    translate([-nub2_size.x/2, 0, 1-enlarge/2]){
        cube(nub2_size);
    }
}

module micro_sd_slot(){
    
    color("Silver"){
        translate_y(1.5){
            difference(){
                translate_x(-12/2){
                    cube([12 , 11.3, 1.5]);
                }
                translate_z(.75){
                    cube([11.5 , 20, 1], center=true);
                }
                translate([1, 0, 1.5]){
                    cube([8 , 3, 2], center=true);
                }
            }
        }
    }
}

module double_header_pins(rows=20){
    for (row_num = [0:rows-1]){
        translate_x(row_num*2.54){
            double_header_pin();
        }
    }
}

module double_header_pin(){
    translate_x(2.54/2){
        color("DimGray"){
            hull(){
                for (y_tr = [1.4, -1.4]){
                    translate_y(y_tr){
                        cylinder(d=2.54, h=2.3, $fn=6);
                    }
                }
            }
        }
        color("Gold"){
            for (y_tr = [2.54/2, -2.54/2]){
                translate([-0.3, -0.3+y_tr, -3]){
                    cube([0.6, 0.6, 11.5]);
                }
            }
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
        filleted_board([x, y, t], r=2, center=true);
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
        translate_z(1.6){
            difference(){
                cylinder(d=22.7,h=7);
                cylinder(d=19,h=99, center=true);
            }
            difference(){
                cylinder(d1 = 7, d2=22.7,h=7);
                translate_z(-0.05){
                    cylinder(d1 = 4.8, d2=19, h=7.1);
                }
            }
        }
    }
}

module motor28BYJ48_body(){
    holes = [[17.5, 0, 0], [-17.5, 0, 0]];
    translate_y(8){
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
            translate_z(7.7/2){
                cube([13.2, 4, 7.7], center=true);
            }
            translate([0, .7/2, 7.3]){
                cube([14.6, 4.7, 0.8], center=true);
            }
            // the "clip"
            jst_connector_clip();
        }
        translate_y(-1.6){
            cube([99, 4, .6], center=true);
        }
        for (x_pin = [-2, -1, 0, 1, 2]*2.54){
            translate_x(x_pin){
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
        translate_y(2){
            cube([1.2, 2, 6], center=true);
        }
        translate_z(6){
            cube([2, 2.8, 10], center=true);
        }
        translate([0, .5, 6]){
            cube([1.2, 2.8, 10], center=true);
        }
        translate_y(-.7){
            cube([1, 1, 10], center=true);
        }
}


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

//board only ever centres in xy
module filleted_board(size, r=2, center=false){

    x_tr1 = center ? size.x/2-r : r;
    x_tr2 = center ? -(size.x/2-r) : size.x-r;
    y_tr1 = center ? size.y/2-r : r;
    y_tr2 = center ? -(size.y/2-r) : size.y-r;
    hull(){
        translate([x_tr1, y_tr1, 0]){
            cylinder(r=r, h=size.z);
        }
        translate([x_tr1, y_tr2, 0]){
            cylinder(r=r, h=size.z);
        }
        translate([x_tr2, y_tr1, 0]){
            cylinder(r=r, h=size.z);
        }
        translate([x_tr2, y_tr2, 0]){
            cylinder(r=r, h=size.z);
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