use <../../openscad/libs/microscope_parameters.scad>
use <../../openscad/libs/libdict.scad>
use <../../openscad/lens_tool.scad>
use <../../openscad/libs/z_axis.scad>
use <../../openscad/libs/illumination.scad>
use <render_utils.scad>

function render_params() =  let(
    params = default_params()
) replace_value("print_ties", false, params);

PARAMS = render_params();

function z_actuator_rot() = [z_actuator_tilt(PARAMS), 0, 0];

function tr_along_z_act(dist) = let(
    ang = z_actuator_tilt(PARAMS)
) [0, -dist*sin(ang), dist*cos(ang)];


//convenience function as the actuator height is used a lot
function actuator_height() = key_lookup("actuator_h", PARAMS);

function x_nut_placement() =  let(
    pos = x_actuator_pos(PARAMS) + [0, 0, actuator_height()-4],
    rot = [0, 0, 45]
) create_placement_dict(pos, rot);

function x_nut_placement_exp() =  let(
    pos = [70, 70, actuator_height()-10],
    rot = [0, 0, 45]
) create_placement_dict(pos, rot);

function y_nut_placement() =  let(
    pos = y_actuator_pos(PARAMS) + [0, 0, actuator_height()-4],
    rot = [0, 0, -45]
) create_placement_dict(pos, rot);

function z_nut_placement() =  let(
    pos = z_actuator_pos(PARAMS) + tr_along_z_act(actuator_height()-4),
    rot1 = [0, 0, 30],
    rot2 = z_actuator_rot()
) create_placement_dict(pos, rot2, rot1);

function x_lead_assembly_pos() = x_actuator_pos(PARAMS) + [0, 0, actuator_height()+7];
function y_lead_assembly_pos() = y_actuator_pos(PARAMS) + [0, 0, actuator_height()+7];
function z_lead_assembly_pos() = z_actuator_pos(PARAMS) + tr_along_z_act(actuator_height()+5);

function x_lead_assembly_placement() = create_placement_dict(x_lead_assembly_pos());
function x_lead_assembly_placement_exp() = create_placement_dict(x_lead_assembly_pos() + [0, 0, 30]);
function y_lead_assembly_placement() = create_placement_dict(y_lead_assembly_pos());
function z_lead_assembly_placement() = create_placement_dict(z_lead_assembly_pos(), z_actuator_rot());

function x_foot_placement() = create_placement_dict(x_actuator_pos(PARAMS), [0, 0, -45]);
function y_foot_placement() = create_placement_dict(y_actuator_pos(PARAMS), [0, 0, 45]);
function z_foot_placement() = create_placement_dict(z_actuator_pos(PARAMS));

function z_oring_placement() = create_placement_dict(z_actuator_pos(PARAMS)+[0, .5, 1.5],
                                                     z_actuator_rot());

function optics_module_pos() = create_placement_dict([0, 0, 0]);
function optics_module_pos_above_tool() = create_placement_dict([0, 0, 75] ,[0, 180, 0], [0, 0, 180]);
function optics_module_pos_on_tool() = create_placement_dict([0, 0, 42] ,[0, 180, 0], [0, 0, 180]);

function tube_lens_tool_pos() = create_placement_dict([0, 0, lens_tool_height()+3.6], [0, 180, 0]);
function optics_module_mount_pos() = objective_mount_screw_pos(PARAMS);

function optics_module_nut_pos() = create_placement_dict(optics_module_mount_pos() - [0, 3.25, 1], [90, 0, 0], [0, 0, 30]);
function optics_module_screw_pos() = create_placement_dict(optics_module_mount_pos() - [0, -4, 1], [-90, 0, 0], [0, 0, 30]);

function condenser_z() = illumination_dovetail_z(PARAMS) + 65;
function condenser_angle() = key_lookup("condenser_angle", PARAMS);
function condenser_pos() = create_placement_dict([0, 0, condenser_z()], [0, 0, 180], [180+condenser_angle(), 0, 0]);
function condenser_pos_above_tool() = create_placement_dict([0, 0, 90],
                                                            [0, 0, -90],
                                                            [180+condenser_angle(), 0, 0]);
function condenser_pos_on_tool() = create_placement_dict([0, 0, 57],
                                                         [0, 0, -90],
                                                         [180+condenser_angle(), 0, 0]);

function condenser_lens_tool_pos() = create_placement_dict([0, 0, lens_tool_height()+1.51]);