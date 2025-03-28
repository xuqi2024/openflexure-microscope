// A holder for a DHC-N01 C-chip to align with the grid.

use <./libs/microscope_parameters.scad>
use <./libs/utilities.scad>
use <./libs/libdict.scad>

C_CHIP_DIMS = [25, 75, 1.7];
C_CHIP_CHAMBER_POS = [-12.5, -28, 0];


c_chip_holder(default_params(), C_CHIP_DIMS, C_CHIP_CHAMBER_POS);

function chip_protrusion() = 10;

module c_chip_holder(params, c_chip_dims, c_chip_chamber_pos){

    block_dims = c_chip_dims + [17, 0, 5];
    block_pos = [-block_dims.x/2, c_chip_chamber_pos.y-chip_protrusion(), 0];
    
    internal_corner_position = c_chip_chamber_pos;
    clamp_corner_position = c_chip_chamber_pos+[c_chip_dims.x, c_chip_dims.y, 0];

    leg_r = key_lookup("leg_r", params);
    hole_dist = leg_r-stage_hole_inset();

    hole_positions = [[-hole_dist, 0, 0], [hole_dist, 0, 0]];

    difference(){
        union(){
            translate(block_pos){
                cube(block_dims);
            }
            hull(){
                for (hole_pos = hole_positions){
                    translate(hole_pos){
                        cylinder(d=10, h=block_dims.z);
                    }
                }
            }
        }

        translate(block_pos+[block_dims.x, 0, 0]){
            rotate(45){
                cube([30, 30, 3*block_dims.z], center=true);
            }
        }

        difference(){
            slide_cutout(c_chip_dims, c_chip_chamber_pos, block_dims.z);
            translate(block_pos+[block_dims.x, 0, block_dims.z]){
                rotate(45){
                    cube([40, 40, block_dims.z], center=true);
                }
            }
        }
        translate_x(c_chip_dims.x/2){
            cube([10, 20, block_dims.z], center=true);
        }
        
        translate(internal_corner_position){
            cylinder(d=5, h=3*block_dims.z, center=true, $fn=16);
        }

        for (hole_pos = hole_positions){
            translate(hole_pos + [0, 0, 2]){
                m3_cap_counterbore(10, 10);
            }
        }
    }
    translate_x(c_chip_dims.x/2+4.4){
        scale([.45, 1])
        difference(){
            cylinder(r=11, h=block_dims.z/2-1);
            cylinder(r=10, h=block_dims.z, center=true);
            translate_x(15){
                cube([30, 30, 30],center=true);
            }
        }
    }
}

module slide_cutout(c_chip_dims, c_chip_chamber_pos, h){
    slope_ratio = 2;
    xy_offset = c_chip_dims.z/slope_ratio;
    // create a clear hole with a bridge for support. Offset over 2 sides of the chip
    translate(c_chip_chamber_pos+[xy_offset, xy_offset, -1]){
        cube([c_chip_dims.x, c_chip_dims.y, c_chip_dims.z*2]);
        cube([c_chip_dims.x, c_chip_dims.y-chip_protrusion()-8, h+2]);
    }
    //Add angled so cutout only touches top of the slide
    hull(){
        translate(c_chip_chamber_pos){
            translate([-xy_offset, -xy_offset, -tiny()]){
                cube([c_chip_dims.x, c_chip_dims.y, tiny()]);
            }
            translate([xy_offset, xy_offset, 2*c_chip_dims.z-tiny()]){
                cube([c_chip_dims.x, c_chip_dims.y, tiny()]);
            }
            translate([xy_offset, -xy_offset, -tiny()]){
                cube([c_chip_dims.x, c_chip_dims.y+2*xy_offset, tiny()]);
            }
        }
    }
}

