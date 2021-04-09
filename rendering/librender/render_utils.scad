use <../../openscad/libs/microscope_parameters.scad>
use <../../openscad/libs/libdict.scad>
use <../../openscad/libs/utilities.scad>

module construction_line(p1, p2, width=0.1, line_color="Black"){
    //draws a construction line between two points. Inputs can be x,y,z list or placement dictionary

    //If placment dictionaries are used then recall using vector
    if (valid_dict(p1)){
        construction_line(key_lookup("translation", p1), p2, width=width, line_color=line_color);
    }else{
        if (valid_dict(p2)){
            construction_line(p1, key_lookup("translation", p2), width=width, line_color=line_color);
        }else{
            color(line_color){
                hull(){
                    translate(p1){
                        cube([width, width, width], center=true);
                    }
                    translate(p2){
                        cube([width, width, width], center=true);
                    }
                }
            }
        }
    }
}

module turn_anticlockwise(rad = 5, head = 2.5){
    color("black"){
        rotate_extrude(angle=270, $fn=80){
            translate_x(rad){
                circle(r = 0.1);
            }
        }
        translate_y(-rad){
            rotate_y(90){
                cylinder(d1=head*2/3, d2=0.01, h=head, $fn=80);
            }
        }
    }
}

module turn_clockwise(rad = 5, head = 2.5){
    mirror([0, 1, 0]){
        turn_anticlockwise(rad, head);
    }
}


function create_placement_dict(translation=[0,0,0],
                               rotation3=[0,0,0],
                               rotation2=[0,0,0],
                               rotation1=[0,0,0]) = [["translation",translation],
                                                     ["rotation3",rotation3],
                                                     ["rotation2",rotation2],
                                                     ["rotation1",rotation1]];

function translate_pos(placement_dict, translation) = let(
    tr = key_lookup("translation", placement_dict) + translation
) replace_value("translation", tr, placement_dict);

module place_part(position){
    if (valid_dict(position)){
        // Places part in 3D space
        // input is a dictionary with keys translation, rotation3, rotation2, rotation1, translation
        // These will be applied in order allowing full ridgidbody rotation before translation
        tr = key_lookup("translation", position);
        r1 = key_lookup("rotation1", position);
        r2 = key_lookup("rotation2", position);
        r3 = key_lookup("rotation3", position);
        translate(tr){
            rotate(r3){
                rotate(r2){
                    rotate(r1){
                        children();
                    }
                }
            }
        }
    }
    else{
        translate(position){
            children();
        }
    }
}

module coloured_render(colour="Red", convexity=6){
    color(colour){
        render(convexity){
            children();
        }
    }
}

module cutaway(dir="+x", colour="Red"){
    if (dir == "none"){
        coloured_render(colour){
            children();
        }
    }
    else{
        rotations = [["x", [0, 90, 0]],
                    ["+x", [0, 90, 0]],
                    ["-x", [0, -90, 0]],
                    ["y", [-90, 0, 0]],
                    ["+y", [-90, 0, 0]],
                    ["-y", [90, 0, 0]],
                    ["z", [0, 0, 0]],
                    ["+z", [0, 0, 0]],
                    ["-z", [0, 180, 0]]];
        rotation = key_lookup(dir, rotations);
        coloured_render(colour){
            difference(){
                children();
                rotate(rotation){
                    cylinder(r=999,h=999,$fn=4); //cutaway
                }
            }
        }
    }
}
