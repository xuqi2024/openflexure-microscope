
use <../openscad/libs/libdict.scad>

use <librender/render_utils.scad>
use <librender/electronics.scad>




module render_frame(frame_dict){

    exploded = key_lookup("exploded", frame_dict);
    arrow = key_lookup("arrow", frame_dict);
    removed = key_lookup("removed", frame_dict);

    tool_pos_exp = create_placement_dict([0, 0, 25]);
    tool_pos_inplace = create_placement_dict([0, 0, 5]);
    tool_pos_final = create_placement_dict([0, 35, 5], [0, 180, 0]);
    lens_pos = create_placement_dict([0, 35, 7], [0, 180, 0]);

    tool_pos_over_cam =  exploded ? tool_pos_exp : tool_pos_inplace;
    tool_pos = removed ? tool_pos_final : tool_pos_over_cam;



    if (exploded){
        construction_line(tool_pos_inplace, tool_pos_exp);
    }
    if (arrow){
        translate([0, 0, 10]){
            turn_anticlockwise(15);
        }
    }

    place_part(tool_pos){
        picamera2_tool();
    }

    if (removed){
        place_part(lens_pos){
            picamera2_lens();
        }
    }

    picamera2(lens = !removed);

}

frame1 = [["exploded", true],
          ["arrow", false],
          ["removed", false]];

frame2 = [["exploded", false],
          ["arrow", true],
          ["removed", false]];

frame3 = [["exploded", false],
          ["arrow", false],
          ["removed", true]];


FRAME=3;

if (FRAME==1){
    render_frame(frame1);
}else if (FRAME==2){
    render_frame(frame2);
}
else if (FRAME==3){
    render_frame(frame3);
}

