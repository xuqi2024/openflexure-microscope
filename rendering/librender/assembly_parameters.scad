include <../../openscad/libs/microscope_parameters.scad>
use <../../openscad/libs/libdict.scad>
use <render_utils.scad>

function render_params() =  let(
    params = default_params()
) replace_value("print_ties", false, params);

_params = render_params();

function x_actuator_pos() = let(
    leg_r = key_lookup("leg_r", _params),
    actuating_nut_r = actuating_nut_r(_params),
    nut_dist = (leg_r+actuating_nut_r)/sqrt(2)
) [nut_dist, nut_dist, 0];

function y_actuator_pos() = let(
    x_pos = x_actuator_pos()
) [-x_pos.x, x_pos.y, x_pos.z];

function z_actuator_pos() = [0, z_nut_y(_params), 0];
function z_actuator_rot() = [z_actuator_tilt(_params), 0, 0];

function tr_along_z_act(dist) = let(
    ang = z_actuator_tilt(_params)
) [0, -dist*sin(ang), dist*cos(ang)];


//convenience function as the actuator height is used a lot
function actuator_height() = key_lookup("actuator_h", _params);

function x_nut_placement() =  let(
    pos = x_actuator_pos() + [0, 0, actuator_height()-4],
    rot = [0, 0, 45]
) create_placement_dict(pos, rot);

function x_nut_placement_exp() =  let(
    pos = [70, 70, actuator_height()-10],
    rot = [0, 0, 45]
) create_placement_dict(pos, rot);

function y_nut_placement() =  let(
    pos = y_actuator_pos() + [0, 0, actuator_height()-4],
    rot = [0, 0, -45]
) create_placement_dict(pos, rot);

function z_nut_placement() =  let(
    pos = z_actuator_pos() + tr_along_z_act(actuator_height()-4),
    rot1 = [0, 0, 30],
    rot2 = z_actuator_rot()
) create_placement_dict(pos, rot2, rot1);

function x_lead_assembly_pos() = x_actuator_pos() + [0, 0, actuator_height()+7];
function y_lead_assembly_pos() = y_actuator_pos() + [0, 0, actuator_height()+7];
function z_lead_assembly_pos() = z_actuator_pos() + tr_along_z_act(actuator_height()+5);

function x_lead_assembly_placement() = create_placement_dict(x_lead_assembly_pos());
function x_lead_assembly_placement_exp() = create_placement_dict(x_lead_assembly_pos() + [0, 0, 30]);
function y_lead_assembly_placement() = create_placement_dict(y_lead_assembly_pos());
function z_lead_assembly_placement() = create_placement_dict(z_lead_assembly_pos(), z_actuator_rot());

function x_foot_placement() = create_placement_dict(x_actuator_pos(), [0, 0, -45]);
function y_foot_placement() = create_placement_dict(y_actuator_pos(), [0, 0, 45]);
function z_foot_placement() = create_placement_dict(z_actuator_pos());

function z_oring_placement() = create_placement_dict(z_actuator_pos()+[0, .5, 1.5],
                                                     z_actuator_rot());