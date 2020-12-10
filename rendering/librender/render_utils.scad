include <../../openscad/libs/microscope_parameters.scad>
use <../../openscad/libs/libdict.scad>

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

function create_placement_dict(translation=[0,0,0],
                               rotation3=[0,0,0],
                               rotation2=[0,0,0],
                               rotation1=[0,0,0]) = [["translation",translation],
                                                     ["rotation3",rotation3],
                                                     ["rotation2",rotation2],
                                                     ["rotation1",rotation1]];

module place_part(placement_dict){
    // Places part in 3D space
    // input is a dictionary with keys translation, rotation3, rotation2, rotation1, translation
    // These will be applied in order allowing full ridgidbody rotation before translation
    tr = key_lookup("translation", placement_dict);
    r1 = key_lookup("rotation1", placement_dict);
    r2 = key_lookup("rotation2", placement_dict);
    r3 = key_lookup("rotation3", placement_dict);
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